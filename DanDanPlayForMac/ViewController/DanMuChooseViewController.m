//
//  DanMuChooseViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuChooseViewController.h"
#import "DanMuChooseViewModel.h"
#import "JHProgressHUD.h"
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
    [self.vm downThirdPartyDanMuWithIndex:[self.episodeButton indexOfSelectedItem] completionHandler:^(NSDictionary *responseObj) {
        [JHProgressHUD disMiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:self userInfo:responseObj];
        
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
    //不能移除第一个 否则会有问题
    for (int i = 0; i < supplierNum; ++i) {
        [self.providerButton addItemWithTitle: [self.vm providerNameWithIndex: i]];
    }
   // [self.providerButton selectItemAtIndex: 0];
  //  [self.providerButton setTitle: [self.providerButton titleOfSelectedItem]];
}

- (void)reloadShiBanButton{
    [self.shiBanBurron removeAllItems];
    
    NSInteger shiBanNum = [self.vm shiBanNum];
    for (int i = 0; i < shiBanNum; ++i) {
        [self.shiBanBurron addItemWithTitle: [self.vm shiBanTitleWithIndex: i]];
    }
    //[self.shiBanBurron selectItemAtIndex: 0];
   // [self.shiBanBurron setTitle: [self.shiBanBurron titleOfSelectedItem]];
}

- (void)reloadEpisodeButton{
    [self.episodeButton removeAllItems];
    
    NSInteger episodeNum = [self.vm episodeNum];
    
    for (int i = 0; i < episodeNum; ++i) {
        [self.episodeButton addItemWithTitle: [self.vm episodeTitleWithIndex: i]];
    }
   // [self.episodeButton selectItemAtIndex: 0];
    //[self.episodeButton setTitle: [self.episodeButton titleOfSelectedItem]];
}

@end
