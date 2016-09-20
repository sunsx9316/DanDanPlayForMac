//
//  BiliBiliDanmakuChooseViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartyDanmakuChooseViewController.h"
#import "BiliBiliDanMuChooseViewModel.h"
#import "AcFunDanMuChooseViewModel.h"
#import "DownLoadOtherDanmakuViewController.h"
#import "LocalVideoModel.h"

@interface ThirdPartyDanmakuChooseViewController ()
@property (weak) IBOutlet NSPopUpButton *episodeButton;
@property (strong, nonatomic) ThirdPartyDanmakuChooseViewModel *vm;
@end

@implementation ThirdPartyDanmakuChooseViewController
#pragma mark - 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView: self.view];
    [self.vm refreshCompletionHandler:^(NSError *error) {
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        [self reloadData];
    }];
}

+ (instancetype)viewControllerWithVideoId:(NSString *)videoId type:(DanDanPlayDanmakuSource)type {
    ThirdPartyDanmakuChooseViewController *vc = [ThirdPartyDanmakuChooseViewController viewController];
    if (type == DanDanPlayDanmakuSourceBilibili) {
        vc.vm = [[BiliBiliDanMuChooseViewModel alloc] initWithAid: videoId];
    }
    else if (type == DanDanPlayDanmakuSourceAcfun){
        vc.vm = [[AcFunDanMuChooseViewModel alloc] initWithAid: videoId];
    }
    return vc;
}

- (IBAction)clickChooseDanMuButton:(NSButton *)sender {
    if (!self.episodeButton.itemTitles.count) return;
    
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeSearchDamakuLoading].message parentView:self.view];
    
    [self.vm downThirdPartyDanmakuWithIndex:[self.episodeButton indexOfSelectedItem] completionHandler:^(id responseObj, NSError *error) {
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        if (!error) {
            
            id<VideoModelProtocol>vm = [UserDefaultManager shareUserDefaultManager].currentVideoModel;
            if (vm) {
                vm.matchTitle = [self.episodeButton titleOfSelectedItem];
                vm.danmakuDic = responseObj;
                //通知开始播放
                [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAY" object:@[vm]];
            }
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
    DanDanPlayDanmakuSource danmakuSource = [self.vm isKindOfClass:[BiliBiliDanMuChooseViewModel class]] ? DanDanPlayDanmakuSourceBilibili : DanDanPlayDanmakuSourceAcfun;
    DownLoadOtherDanmakuViewController *vc = [DownLoadOtherDanmakuViewController viewController];
    vc.videos = self.vm.videos;
    vc.source = danmakuSource;
    [self presentViewControllerAsModalWindow:vc];
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
