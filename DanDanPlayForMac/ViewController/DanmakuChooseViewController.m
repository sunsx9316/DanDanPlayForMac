//
//  DanmakuChooseViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanmakuChooseViewController.h"
#import "DanMuChooseViewModel.h"
#import "VideoInfoModel.h"
#import "DownLoadOtherDanmakuViewController.h"
#import "HUDMessageView.h"

@interface DanmakuChooseViewController ()
@property (weak) IBOutlet NSPopUpButton *providerButton;
@property (weak) IBOutlet NSPopUpButton *shiBanBurron;
@property (weak) IBOutlet NSPopUpButton *episodeButton;
@property (strong, nonatomic) DanMuChooseViewModel *vm;
@property (strong, nonatomic) HUDMessageView *messageView;
@end

@implementation DanmakuChooseViewController

- (void)viewDidAppear {
    [super viewDidAppear];
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView: self.view];
    [self.vm refreshCompletionHandler:^(NSError *error) {
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        if (self.vm.contentDic.count) {
            [self reloadData];
        }
        else {
            [self.messageView showHUD];
        }
    }];
}

//点击确认 发送播放通知
- (IBAction)clickOKButton:(NSButton *)sender {
    if (!self.episodeButton.itemTitles.count) return;
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeSearchDamakuLoading].message parentView:self.view];
    
    NSUInteger index = [self.episodeButton indexOfSelectedItem];
    DanDanPlayDanmakuSource source = [ToolsManager enumValueWithDanmakuSourceStringValue:[self.providerButton titleOfSelectedItem]];
    
    [self.vm downThirdPartyDanmakuWithIndex:index provider:source completionHandler:^(id responseObj) {
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        NSString *shiBanTitle = [self.shiBanBurron titleOfSelectedItem];
        NSString *episodeTitle = [self.episodeButton titleOfSelectedItem];
        
       id<VideoModelProtocol>vm = [UserDefaultManager shareUserDefaultManager].currentVideoModel;
        if (vm) {
            vm.matchTitle = [shiBanTitle stringByAppendingString: episodeTitle];
            vm.danmakuDic = responseObj;
            //通知开始播放
            [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAY" object:@[vm]];
        }
    }];
}

- (IBAction)clickBackButton:(NSButton *)sender {
    [self dismissController: self];
}

- (IBAction)clickDownOtherDanmakuButton:(NSButton *)sender {
    NSArray *arr = self.vm.episodeTitleArr;
    if (arr.count) {
        DanDanPlayDanmakuSource source = [ToolsManager enumValueWithDanmakuSourceStringValue:[self.providerButton titleOfSelectedItem]];
        DownLoadOtherDanmakuViewController *vc = [DownLoadOtherDanmakuViewController viewController];
        vc.videos = arr;
        vc.source = source;
        [self presentViewControllerAsModalWindow:vc];
    }
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

- (void)reloadShiBanButton {
    [self.shiBanBurron removeAllItems];
    
    NSInteger shiBanNum = [self.vm shiBanNum];
    for (int i = 0; i < shiBanNum; ++i) {
        [self.shiBanBurron addItemWithTitle: [self.vm shiBanTitleWithIndex: i]];
    }
}

- (void)reloadEpisodeButton {
    [self.episodeButton removeAllItems];
    
    NSInteger episodeNum = [self.vm episodeNum];
    
    for (int i = 0; i < episodeNum; ++i) {
        [self.episodeButton addItemWithTitle: [self.vm episodeTitleWithIndex: i]];
    }
}

#pragma mark setter getter
- (void)setVideoId:(NSString *)videoId {
    self.vm.videoId = videoId;
}

- (NSString *)videoId {
    return self.vm.videoId;
}

#pragma mark - 懒加载
- (DanMuChooseViewModel *)vm {
	if(_vm == nil) {
		_vm = [[DanMuChooseViewModel alloc] init];
	}
	return _vm;
}

- (HUDMessageView *)messageView {
    if(_messageView == nil) {
        _messageView = [[HUDMessageView alloc] init];
        _messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
    }
    return _messageView;
}

@end
