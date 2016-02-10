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

@interface ThirdPartyDanMuChooseViewController ()
@property (weak) IBOutlet NSPopUpButton *episodeButton;
@property (strong, nonatomic) ThirdPartyDanMuChooseViewModel *vm;
@end

@implementation ThirdPartyDanMuChooseViewController
#pragma mark - 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView: self.view];
    [self.vm refreshCompletionHandler:^(NSError *error) {
        [JHProgressHUD disMiss];
        [self reloadData];
    }];
}

- (instancetype)initWithVideoID:(NSString *)videoID type:(kDanMuSource)type{
    if ((self = kViewControllerWithId(@"ThirdPartyDanMuChooseViewController"))) {
        if (type == bilibili) {
            self.vm = [[BiliBiliDanMuChooseViewModel alloc] initWithAid: videoID];
        }else if (type == acfun){
            self.vm = [[AcFunDanMuChooseViewModel alloc] initWithAid: videoID];
        }
    }
    return self;
}


- (IBAction)clickChooseDanMuButton:(NSButton *)sender {
    [JHProgressHUD showWithMessage:@"挖坟中..." parentView:self.view];
    
    [self.vm downThirdPartyDanMuWithIndex:[self.episodeButton indexOfSelectedItem] completionHandler:^(NSDictionary *responseObj, NSError *error) {
        [JHProgressHUD disMiss];
        if (!error) {
            //通知更新匹配名称
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mathchVideo" object:self userInfo:@{@"animateTitle": [self.episodeButton titleOfSelectedItem]?[self.episodeButton titleOfSelectedItem]:@""}];
            //通知关闭列表视图控制器
            [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:self userInfo:responseObj];
            //通知开始播放
            [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:self userInfo:responseObj];
        }
    }];
}
- (IBAction)clickGoBackButton:(NSButton *)sender {
    [self dismissController: self];
}

- (IBAction)clickChooseEpisodeButton:(NSPopUpButton *)sender {
    [sender setTitle: [sender titleOfSelectedItem]];
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
