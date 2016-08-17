//
//  BiliBiliDanMuChooseViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartyDanMuChooseViewController.h"
#import "BiliBiliDanMuChooseViewModel.h"
#import "AcFunDanMuChooseViewModel.h"
#import "DownLoadOtherDanmakuViewController.h"

@interface ThirdPartyDanMuChooseViewController ()
@property (weak) IBOutlet NSPopUpButton *episodeButton;
@property (strong, nonatomic) ThirdPartyDanMuChooseViewModel *vm;
@end

@implementation ThirdPartyDanMuChooseViewController
#pragma mark - 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [JHProgressHUD showWithMessage:[UserDefaultManager alertMessageWithType:DanDanPlayMessageTypeLoadMessage].message parentView: self.view];
    [self.vm refreshCompletionHandler:^(NSError *error) {
        [JHProgressHUD disMiss];
        [self reloadData];
    }];
}

- (instancetype)initWithVideoID:(NSString *)videoID type:(DanDanPlayDanmakuSource)type {
    if ((self = kViewControllerWithId(@"ThirdPartyDanMuChooseViewController"))) {
        if (type == DanDanPlayDanmakuSourceBilibili) {
            self.vm = [[BiliBiliDanMuChooseViewModel alloc] initWithAid: videoID];
        }else if (type == DanDanPlayDanmakuSourceAcfun){
            self.vm = [[AcFunDanMuChooseViewModel alloc] initWithAid: videoID];
        }
    }
    return self;
}


- (IBAction)clickChooseDanMuButton:(NSButton *)sender {
    if (!self.episodeButton.itemTitles.count) return;
    
    [JHProgressHUD showWithMessage:[UserDefaultManager alertMessageWithType:DanDanPlayMessageTypeSearchDamakuLoading].message parentView:self.view];
    
    [self.vm downThirdPartyDanMuWithIndex:[self.episodeButton indexOfSelectedItem] completionHandler:^(id responseObj, NSError *error) {
        [JHProgressHUD disMiss];
        if (!error) {
            //通知更新匹配名称
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MATCH_VIDEO" object:self userInfo:@{@"animateTitle": [self.episodeButton titleOfSelectedItem]?[self.episodeButton titleOfSelectedItem]:@""}];
            //通知关闭列表视图控制器
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DISSMISS_VIEW_CONTROLLER" object:self userInfo:nil];
            //通知开始播放
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:self userInfo:responseObj];
        }
    }];
}
- (IBAction)clickGoBackButton:(NSButton *)sender {
    [self dismissController: self];
}

- (IBAction)clickChooseEpisodeButton:(NSPopUpButton *)sender {
    [sender setTitle: [sender titleOfSelectedItem]];
}

- (IBAction)clickDownLoadOtherDanmakuButton:(NSButton *)sender {
    DanDanPlayDanmakuSource danMuSource = [self.vm isKindOfClass:[BiliBiliDanMuChooseViewModel class]] ? DanDanPlayDanmakuSourceBilibili : DanDanPlayDanmakuSourceAcfun;
    [self presentViewControllerAsModalWindow:[[DownLoadOtherDanmakuViewController alloc] initWithVideos:self.vm.videos danMuSource:danMuSource]];
}


#pragma mark - 私有方法
- (void)reloadData{
    [self.episodeButton removeAllItems];
    
    NSInteger shiBanNum = [self.vm episodeCount];
    for (int i = 0; i < shiBanNum; ++i) {
        [self.episodeButton addItemWithTitle: [self.vm episodeTitleWithIndex: i]];
    }
}
@end
