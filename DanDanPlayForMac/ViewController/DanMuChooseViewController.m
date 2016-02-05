//
//  DanMuChooseViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuChooseViewController.h"
#import "DanMuChooseViewModel.h"
#import "VideoInfoModel.h"

@interface DanMuChooseViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSPopUpButton *providerButton;
@property (weak) IBOutlet NSPopUpButton *shiBanBurron;
@property (weak) IBOutlet NSPopUpButton *episodeButton;
@property (strong, nonatomic) DanMuChooseViewModel *vm;

@end

@implementation DanMuChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView: self.view];
    [self.vm refreshCompletionHandler:^(NSError *error) {
        [JHProgressHUD disMiss];
        [self reloadData];
    }];
}


- (instancetype)initWithVideoID:(NSString *)videoID{
    if ((self = kViewControllerWithId(@"DanMuChooseViewController"))) {
        self.vm = [[DanMuChooseViewModel alloc] initWithVideoID: videoID];
    }
    return self;
}
//点击确认 发送播放通知
- (IBAction)clickOKButton:(NSButton *)sender {
    [JHProgressHUD showWithMessage:@"挖坟中..." parentView:self.view];
    [self.vm downThirdPartyDanMuWithIndex:[self.episodeButton indexOfSelectedItem] provider:[self.providerButton titleOfSelectedItem] completionHandler:^(NSDictionary *responseObj) {
        [JHProgressHUD disMiss];
        //通知关闭列表视图控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:self userInfo:responseObj];
        //通知开始播放
        [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:self userInfo:responseObj];
    }];
}

- (IBAction)clickBackButton:(NSButton *)sender {
    [self dismissController: self];
}

- (IBAction)selectEpisode:(NSPopUpButton *)sender {
    [sender setTitle: [sender titleOfSelectedItem]];
}

- (IBAction)selectShiBan:(NSPopUpButton *)sender {
    NSInteger index = [sender indexOfSelectedItem];
    
    self.vm.episodeTitleArr = self.vm.shiBanArr[index].videos;
    [self reloadEpisodeButton];
    
    [sender setTitle: [sender titleOfSelectedItem]];
    [self.episodeButton setTitle: [self.episodeButton itemTitleAtIndex: 0]];
}

- (IBAction)selectProvider:(NSPopUpButton *)sender {
    NSInteger index = [sender indexOfSelectedItem];
    
    self.vm.shiBanArr = self.vm.contentDic[self.vm.providerArr[index]];
    self.vm.episodeTitleArr = self.vm.shiBanArr.firstObject.videos;
    [self reloadShiBanButton];
    [self reloadEpisodeButton];
    
    [sender setTitle: [sender titleOfSelectedItem]];
    [self.shiBanBurron setTitle: [self.shiBanBurron itemTitleAtIndex: 0]];
    [self.episodeButton setTitle: [self.episodeButton itemTitleAtIndex: 0]];
}

#pragma mark - 私有方法
- (void)reloadData{
    [self reloadShiBanButton];
    [self reloadEpisodeButton];
    [self reloadProviderButton];
}

- (void)reloadProviderButton{
    [self.providerButton removeAllItems];
    
    NSInteger supplierNum = [self.vm providerNum];
    for (int i = 0; i < supplierNum; ++i) {
        [self.providerButton addItemWithTitle: [self.vm providerNameWithIndex: i]];
    }
}

- (void)reloadShiBanButton{
    [self.shiBanBurron removeAllItems];
    
    NSInteger shiBanNum = [self.vm shiBanNum];
    for (int i = 0; i < shiBanNum; ++i) {
        [self.shiBanBurron addItemWithTitle: [self.vm shiBanTitleWithIndex: i]];
    }
}

- (void)reloadEpisodeButton{
    [self.episodeButton removeAllItems];
    
    NSInteger episodeNum = [self.vm episodeNum];
    
    for (int i = 0; i < episodeNum; ++i) {
        [self.episodeButton addItemWithTitle: [self.vm episodeTitleWithIndex: i]];
    }
}

@end
