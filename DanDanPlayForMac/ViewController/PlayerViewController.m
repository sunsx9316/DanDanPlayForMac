//
//  PlayerViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "MatchViewController.h"
#import "SearchViewController.h"
#import "PlayerListViewController.h"
#import "PlayerDanmakuAndSubtitleViewController.h"

#import "HUDMessageView.h"
#import "PlayerHoldView.h"
#import "PlayerControlView.h"
#import "DanmakuColorMenuItem.h"
#import "DanmakuModeMenuItem.h"
#import "RespondKeyboardTextField.h"
#import "AddTrackingAreaButton.h"
#import "VolumeControlView.h"
#import "TimeHUDMessageView.h"
#import "PlayerDanmakuCountView.h"

#import "MatchModel.h"
#import "LocalVideoModel.h"
#import "PlayViewModel.h"

#import "QualityMenuItem.h"

#import "NSColor+Tools.h"
#import "NSButton+Tools.h"
#import "NSAlert+Tools.h"
#import "JHDanmakuEngine+Tools.h"
#import "NSUserNotificationCenter+Tools.h"

#import "PlayerMethodManager.h"
#import "JHDanmakuRender.h"
#import "JHMediaPlayer.h"

#import <POP.h>

//短跳转时长
#define SHORT_JUMP_TIME 5
//普通跳转时长
#define MEDIUM_JUMP_TIME 10
//缓冲自动播放时长
#define MAX_BUFFER_TIME 3
//播放控制面板半激活状态约束
#define PLAY_CONTROL_HALF_ACTIVA_CONSTRAINT @(-weakSelf.playerControlView.frame.size.height + 10)
//播放控制面板失活状态约束
#define PLAY_CONTROL_INACTIVA_CONSTRAINT @(-weakSelf.playerControlView.frame.size.height + 2)
//播放控制面板激活状态约束
#define PLAY_CONTROL_ACTIVA_CONSTRAINT @0
//视频列表展开约束
#define PLAY_CONTROL_LEFT_EXPANSION_CONSTRAINT @(weakSelf.playerListViewController.view.frame.size.width)
//视频列表收缩约束
#define PLAY_CONTROL_LEFT_CONTRACT_CONSTRAINT @0
//弹幕列表展开约束
#define PLAY_CONTROL_RIGHT_EXPANSION_CONSTRAINT @(weakSelf.self.playerDanmakuAndSubtitleViewController.view.frame.size.width)
//弹幕列表收缩约束
#define PLAY_CONTROL_RIGHT_CONTRACT_CONSTRAINT @0


@interface PlayerViewController ()<PlayerSlideViewDelegate, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSUserNotificationCenterDelegate, JHMediaPlayerDelegate, JHDanmakuEngineDelegate>

//放视频的 view
@property (weak) IBOutlet PlayerHoldView *playerHoldView;

/**** 播放面板  ****/
//播放面板
@property (weak) IBOutlet PlayerControlView *playerControlView;
//播放按钮
@property (weak) IBOutlet NSButton *playButton;
//音量按钮
@property (weak) IBOutlet NSButton *volumeButton;
//弹幕隐藏/显示按钮
@property (weak) IBOutlet NSButton *playDanmakuShowButton;
//显示时间的label
@property (weak) IBOutlet NSTextField *timeLabel;
//发送弹幕颜色选择按钮
@property (weak) IBOutlet NSPopUpButton *danmakuColorPopUpButton;
//发送弹幕类型按钮
@property (weak) IBOutlet NSPopUpButton *danmakuModePopUpButton;
//发送弹幕输入框
@property (weak) IBOutlet RespondKeyboardTextField *danmakuTextField;
/**** 播放面板  ****/


//弹幕和字幕控制器
@property (strong, nonatomic) PlayerDanmakuAndSubtitleViewController *playerDanmakuAndSubtitleViewController;
//播放列表控制器
@property (strong, nonatomic) PlayerListViewController *playerListViewController;

//上次播放时间的view
@property (strong) IBOutlet PlayerLastWatchVideoTimeView *lastWatchVideoTimeView;
//弹幕数view
@property (strong) IBOutlet PlayerDanmakuCountView *danmakuCountView;

/**** 右键显示的清晰度菜单  ****/
//右键显示的清晰度菜单
@property (strong) IBOutlet NSMenu *rightClickMenu;
//画质按钮
@property (weak) IBOutlet NSMenuItem *qualityMenuItem;
//缓存视频按钮
@property (weak) IBOutlet NSMenuItem *downloadVideoMenuItem;
/**** 右键显示的清晰度菜单  ****/


//控制弹幕控制面板显示/隐藏的按钮
@property (strong, nonatomic) NSButton *controlDanMakuControllerViewButton;
//控制播放列表面板显示/隐藏的按钮
@property (strong, nonatomic) NSButton *controlPlayListControllerViewButton;

//显示消息的 view
@property (strong, nonatomic) HUDMessageView *messageView;
//音量控制的 view
@property (strong, nonatomic) VolumeControlView *volumeControlView;
//显示在控制面板上面的时间 view
@property (strong, nonatomic) TimeHUDMessageView *HUDTimeView;

//播放控制面板左边的约束
@property (weak) IBOutlet NSLayoutConstraint *playerControlViewLeftConstraint;
//播放控制面板右边的约束
@property (weak) IBOutlet NSLayoutConstraint *playerControlViewRightConstraint;
//播放控制面板底部的约束
@property (weak) IBOutlet NSLayoutConstraint *playerControlViewBottomConstraint;

@property (strong, nonatomic) JHMediaPlayer *player;
@property (strong, nonatomic) JHDanmakuEngine *danmakuEngine;
//快捷键映射
@property (strong, nonatomic) NSArray *keyMap;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@property (strong, nonatomic) JHProgressHUD *bufferProgressHUD;
@property (strong, nonatomic) NSMutableSet <NSNumber *>*globalDanmakuFilter;
@end

@implementation PlayerViewController
{
    //是否处于全屏状态
    BOOL _fullScreen;
    //时间格式化工具
    NSDateFormatter *_formatter;
    NSDateFormatter *_snapshotFormatter;
    NSTimer *_autoHideTimer;
    NSDictionary *_danmakuDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    id<VideoModelProtocol>model = self.vm.currentVideoModel;
    [NSUserNotificationCenter postMatchMessageWithMatchName:model.matchTitle delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuColor:) name:NSColorPanelColorDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFontSpecially:) name:@"CHANGE_FONT_SPECIALLY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuFont:) name:@"CHANGE_DANMAKU_FONT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(danmakuCanvasResizeWithAnimate) name:@"CHANGE_CAPTIONS_PROTECT_AREA" object:nil];
    
    //初始化播放器相关参数
    [self reloadCurrentVideoDanmakuWithCompletionHandler:^(id<VideoModelProtocol>videoModel, NSError *error) {
        [self setupOnce];
//        [self.danmakuEngine sendAllDanmakusDic:self.vm.currentVideoModel.danmakuDic];
        self->_danmakuDic = self.vm.currentVideoModel.danmakuDic;
        self.danmakuEngine.currentTime = self.player.currentTime;
        [self.player videoSizeWithCompletionHandle:^(CGSize size) {
            if (size.width < 0 || size.height < 0) {
                self.messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeVideoNoFound].message;
                [self.messageView showHUD];
                return;
            }
            [self setupWithMediaSize:size];
            [self.player play];
        }];
    }];
}

- (void)dealloc {
    [[ToolsManager shareToolsManager] ableSleep];
    [self pop_removeAllAnimations];
    [self.player removeObserverBlocksForKeyPath:DDP_KEYPATH(self.player, status)];
    [self.playDanmakuShowButton removeObserverBlocksForKeyPath:DDP_KEYPATH(self.playDanmakuShowButton, state)];
    
    [self.view removeTrackingArea:self.trackingArea];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [NSApplication sharedApplication].mainWindow.title = [ToolsManager appName];
}

//全屏
- (void)mouseDown:(NSEvent *)theEvent {
    if (theEvent.clickCount == 1) {
        if (self.playerControlView.leftExpansion) {
            self.playerControlView.leftExpansion = NO;
        }
        
        if (self.playerControlView.rightExpansion) {
            self.playerControlView.rightExpansion = NO;
        }
    }
    else if (theEvent.clickCount == 2) {
        [self toggleFullScreen];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    //只移动 并没有进入播放面板 进入半激活状态
    if (!CGRectContainsPoint(self.playerControlView.frame, theEvent.locationInWindow) && self.playerControlView.status == PlayerControlViewStatusInActive) {
        self.playerControlView.status = PlayerControlViewStatusHalfActive;
    }
    self.controlDanMakuControllerViewButton.animator.alphaValue = 1;
    self.controlPlayListControllerViewButton.animator.alphaValue = 1;
    [_autoHideTimer invalidate];
    //进入激活状态让定时器失活
    if (self.playerControlView.status == PlayerControlViewStatusActive) return;
    
    _autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:AUTO_HIDE_TIME target:self selector:@selector(autoHideMouseControlView) userInfo:nil repeats:NO];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    if ([self.vm.currentVideoModel isKindOfClass:[StreamingVideoModel class]]) {
        [NSMenu popUpContextMenu:self.rightClickMenu withEvent:theEvent forView:self.view];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    int code = theEvent.keyCode;
    NSArray *arr = self.keyMap;
    for (NSDictionary *dic in arr) {
        if ([dic[@"keyCode"] intValue] == code && [dic[@"flag"] unsignedIntegerValue] == flags) {
            [self targetMethodWithId:dic[@"id"]];
            break;
        }
    }
}

//滚轮调整音量
- (void)scrollWheel:(NSEvent *)theEvent {
    int isReverse = [UserDefaultManager shareUserDefaultManager].reverseVolumeScroll ? -1 : 1;
    //判断是否为apple的破鼠标
    if (theEvent.hasPreciseScrollingDeltas) {
        [self volumeValueAddBy:-theEvent.deltaY * isReverse];
    }
    else {
        [self volumeValueAddBy:theEvent.scrollingDeltaY * isReverse];
    }
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"volume"]) {
//        self.volumeControlView.volumeSlider.floatValue = [change[@"new"] floatValue];
//    }
//    // 显示隐藏弹幕按钮
//    else if ([keyPath isEqualToString:@"state"]) {
//        self.danmakuEngine.canvas.animator.hidden = [change[@"new"] intValue];
//    }
//}

#pragma mark - 私有方法
#pragma mark -------- 初始化相关 --------
//只需要初始化一次的属性
- (void)setupOnce {
    __weak typeof(self)weakSelf = self;
    self.view.backgroundColor = [NSColor blackColor];
    //播放器控制面板
    [self.playerControlView setStatusCallBackBlock:^(PlayerControlViewStatus status) {
        if (status == PlayerControlViewStatusActive) {
            [weakSelf.playerControlViewBottomConstraint pop_addAnimation:[weakSelf basicAnimateWithToValue:PLAY_CONTROL_ACTIVA_CONSTRAINT propertyNamed:nil] forKey:@"play_control_activa_anima"];
        }
        else if (status == PlayerControlViewStatusInActive) {
            [weakSelf.playerControlViewBottomConstraint pop_addAnimation:[weakSelf basicAnimateWithToValue:PLAY_CONTROL_INACTIVA_CONSTRAINT propertyNamed:nil] forKey:@"play_control_inactiva_anima"];
        }
        else if (status == PlayerControlViewStatusHalfActive) {
            [weakSelf.playerControlViewBottomConstraint pop_addAnimation:[weakSelf basicAnimateWithToValue:PLAY_CONTROL_HALF_ACTIVA_CONSTRAINT propertyNamed:nil] forKey:@"play_control_half_activa_anima"];
        }
    }];
    
    [self.playerControlView setLeftCallBackBlock:^(BOOL isExpansion) {
        if (isExpansion) {
            [weakSelf.playerControlViewLeftConstraint pop_addAnimation:[weakSelf springAnimateWithToValue:PLAY_CONTROL_LEFT_EXPANSION_CONSTRAINT propertyNamed:nil completionBlock:nil] forKey:@"danmaku_control_view_show_animate"];
        }
        else {
            [weakSelf.playerControlViewLeftConstraint pop_addAnimation:[weakSelf springAnimateWithToValue:PLAY_CONTROL_LEFT_CONTRACT_CONSTRAINT propertyNamed:nil completionBlock:nil] forKey:@"danmaku_control_view_hide_animate"];
            weakSelf.controlPlayListControllerViewButton.animator.alphaValue = 0;
        }
    }];
    
    [self.playerControlView setRightCallBackBlock:^(BOOL isExpansion) {
        if (isExpansion) {
            weakSelf.playerDanmakuAndSubtitleViewController.subtitleVC.subtitleIndexs = weakSelf.player.subtitleIndexs;
            weakSelf.playerDanmakuAndSubtitleViewController.subtitleVC.subtitleTitles = weakSelf.player.subtitleTitles;
            weakSelf.playerDanmakuAndSubtitleViewController.subtitleVC.currentSubtitleIndex = weakSelf.player.currentSubtitleIndex;
            
            [weakSelf.playerControlViewRightConstraint pop_addAnimation:[weakSelf springAnimateWithToValue:PLAY_CONTROL_RIGHT_EXPANSION_CONSTRAINT propertyNamed:nil completionBlock:nil] forKey:@"play_list_view_show_animate"];
        }
        else {
            [weakSelf.playerControlViewRightConstraint pop_addAnimation:[weakSelf springAnimateWithToValue:PLAY_CONTROL_RIGHT_CONTRACT_CONSTRAINT propertyNamed:nil completionBlock:nil] forKey:@"play_list_view_hide_animate"];
            weakSelf.controlDanMakuControllerViewButton.animator.alphaValue = 0;
        }
    }];
    
    [self.playerControlView.slideView setMouseExitedCallBackBlock:^{
        [weakSelf.HUDTimeView hide];
    }];
    [self.playerControlView.slideView setMouseEnteredCallBackBlock:^{
        [weakSelf.HUDTimeView show];
    }];
    self.playerControlView.slideView.delegate = self;
    
    //左右两边的页面
    [self.playerDanmakuAndSubtitleViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(500);
        make.bottom.top.mas_equalTo(0);
        make.left.equalTo(self.playerControlView.mas_right);
    }];
    
    [self.playerListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(self.playerControlView.mas_left);
    }];
    
    self.controlDanMakuControllerViewButton.alphaValue = 0;
    self.controlPlayListControllerViewButton.alphaValue = 0;
    
    //拖放文件回调
    [self.playerHoldView setFilePickBlock:^(NSArray <NSURL *>*filePaths) {
        if (filePaths.count > 0) {
            //尝试从路径读取弹幕
            [PlayerMethodManager convertDanmakuWithURL:filePaths.firstObject completionHandler:^(NSDictionary *danmakuDic, DanDanPlayErrorModel *error) {
                if (error) {
                    //转换成模型
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSURL *url in filePaths) {
                        LocalVideoModel *vm = [[LocalVideoModel alloc] initWithFileURL:url];
                        [arr addObject:vm];
                    }
                    [weakSelf.vm addVideosModel:arr];
                    NSInteger index = [weakSelf.vm.videos indexOfObject:arr.firstObject];
                    [weakSelf saveTimeAndChangeCurrentIndex:index];
                    [weakSelf reloadCurrentVideoDanmakuWithCompletionHandler:^(id<VideoModelProtocol> videoModel, NSError *error) {
                        if (!error) {
                            [weakSelf reloadVideoModel];
                        }
                    }];
                }
                else {
                    __strong typeof(weakSelf)self = weakSelf;
                    self.vm.currentVideoModel.danmakuDic = danmakuDic;
                    self->_danmakuDic = danmakuDic;
                    self.danmakuEngine.currentTime = self.player.currentTime;
//                    [weakSelf.danmakuEngine sendAllDanmakusDic:danmakuDic];
                    weakSelf.danmakuEngine.currentTime = weakSelf.player.currentTime;
                }
            }];
        }
    }];
    
    //设置发送弹幕输入框回调
    [self.danmakuTextField setRespondBlock:^{
        [weakSelf launchDanmaku];
    }];
    
    //弹幕颜色、样式按钮
    NSArray *colorArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmaku_color" ofType:@"plist"]];
    for (NSDictionary *dic in colorArr) {
        DanmakuColorMenuItem *item = [[DanmakuColorMenuItem alloc] initWithTitle:dic[@"name"] color:[NSColor colorWithRGB:(uint32_t)[dic[@"value"] integerValue]]];
        [self.danmakuColorPopUpButton.menu addItem:item];
    }
    
    [self.danmakuModePopUpButton.menu addItem:[[DanmakuModeMenuItem alloc] initWithMode:1 title:@"滚动弹幕"]];
    [self.danmakuModePopUpButton.menu addItem:[[DanmakuModeMenuItem alloc] initWithMode:4 title:@"顶部弹幕"]];
    [self.danmakuModePopUpButton.menu addItem:[[DanmakuModeMenuItem alloc] initWithMode:5 title:@"底部弹幕"]];
    
    //初始化视频信息
    self.player = [[JHMediaPlayer alloc] initWithMediaURL:self.vm.currentVideoModel.fileURL];
    self.player.delegate = self;
    [self.playerHoldView addSubview:self.player.mediaView];
    
    //音量
    [self.view addSubview:self.volumeControlView positioned:NSWindowAbove relativeTo:self.playerControlView];
//    [self.player addObserver:self forKeyPath:@"volume" options:NSKeyValueObservingOptionNew context:nil];
    
    @weakify(self)
    [self.player addObserverBlockForKeyPath:DDP_KEYPATH(self.player, volume) block:^(id  _Nonnull obj, id  _Nonnull oldVal, NSNumber * _Nonnull newVal) {
        @strongify(self)
        if (!self) {
            return;
        }
        
        if ([newVal isKindOfClass:[NSNumber class]]) {
            self.volumeControlView.volumeSlider.floatValue = [newVal floatValue];
        }
    }];
    
    [self.volumeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(150);
        make.centerX.equalTo(self.volumeButton);
        make.bottom.equalTo(self.volumeButton.mas_top).mas_offset(-10);
    }];
    [self.volumeControlView hide];
    self.player.volume = self.volumeControlView.volumeSlider.floatValue;
    [self.volumeButton setTarget:self];
    [self.volumeButton setAction:@selector(clickVolumeButton:)];
    
    //上次观看时间视图
    [self.view addSubview:self.lastWatchVideoTimeView positioned:NSWindowAbove relativeTo:self.danmakuEngine.canvas];
    //点击上次播放时间回调
    [self.lastWatchVideoTimeView setContinusBlock:^(NSTimeInterval time) {
        [weakSelf.player setPosition:time / weakSelf.player.length completionHandler:^(NSTimeInterval time) {
            weakSelf.danmakuEngine.currentTime = time;
        }];
    }];
    
    [self.lastWatchVideoTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(-self.lastWatchVideoTimeView.frame.size.width);
        make.centerY.mas_offset(90);
    }];
    
    //弹幕数量视图
    [self.view addSubview:self.danmakuCountView positioned:NSWindowAbove relativeTo:self.danmakuEngine.canvas];
    [self.danmakuCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastWatchVideoTimeView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(-self.danmakuCountView.frame.size.width);
        make.height.equalTo(self.lastWatchVideoTimeView);
    }];
    
    //监听弹幕显示/隐藏按钮状态
    [self.playDanmakuShowButton addObserverBlockForKeyPath:DDP_KEYPATH(self.playDanmakuShowButton, state) block:^(id  _Nonnull obj, id  _Nonnull oldVal, NSNumber * _Nonnull newVal) {
        @strongify(self)
        if (!self) {
            return;
        }
        
        if ([newVal isKindOfClass:[NSNumber class]]) {
            self.danmakuEngine.canvas.animator.hidden = newVal.boolValue;
        }
    }];
//    [self.playDanmakuShowButton addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    //时间缩略图
    [self.view addSubview:self.HUDTimeView positioned:NSWindowAbove relativeTo:self.playerControlView];
    [self.view addTrackingArea:self.trackingArea];
}

- (void)setupWithMediaSize:(CGSize)aMediaSize {
    //重设mediaView的约束
    [PlayerMethodManager remakeConstraintsPlayerMediaView:self.player.mediaView size:aMediaSize];
    
    //设置其它参数
    NSString *title = self.vm.currentVideoModel.fileName;
    [NSApplication sharedApplication].keyWindow.title = title;
    self.playerControlView.status = PlayerControlViewStatusHalfActive;
    //只有官方弹幕库启用发送弹幕功能
    if (self.vm.currentVideoModel.episodeId.length == 0) {
        self.danmakuTextField.enabled = NO;
        self.danmakuTextField.placeholderString = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeCannotLaunchDanmakuPlaceHold].message;
    }
    else {
        self.danmakuTextField.enabled = YES;
        self.danmakuTextField.placeholderString = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeCanLaunchDanmakuPlaceHolder].message;
    }
    //重设右键菜单
    [self resetMenuByOpenStreamDic];
    //显示上次播放进度
    NSInteger intTime = [self.vm currentVideoLastVideoTime];
    if (intTime > 0) {
        self.lastWatchVideoTimeView.videoTimeTextField.text = [NSString stringWithFormat:@"上次播放时间: %.2ld:%.2ld",intTime / 60, intTime % 60];
        self.lastWatchVideoTimeView.time = intTime;
        [self.lastWatchVideoTimeView show];
    }
    
    self.danmakuCountView.danmakuCount = self.vm.danmakuCount;
    [self.danmakuCountView show];
    
    //重设视图尺寸
    [self danmakuCanvasResizeWithAnimate:NO];
}

#pragma mark -------- 播放器相关 --------
- (IBAction)clickPlayButton:(NSButton *)sender {
    if (self.player.status == JHMediaPlayerStatusStop) {
        [self.player play];
    }
    else if (sender.state) {
        [self.player play];
    }
    else {
        [self.player pause];
    }
}

- (IBAction)clickNextButton:(NSButton *)sender {
    self.vm.currentIndex += self.vm.currentIndex;
    [self saveTimeAndChangeCurrentIndex:self.vm.currentIndex];
    [self reloadCurrentVideoDanmakuWithCompletionHandler:^(id<VideoModelProtocol>videoModel, NSError *error) {
        if (!error) {
            [self reloadVideoModel];
        }
    }];
}

- (IBAction)clickPreButton:(NSButton *)sender {
    self.vm.currentIndex -= self.vm.currentIndex;
    [self saveTimeAndChangeCurrentIndex:self.vm.currentIndex];
    [self reloadCurrentVideoDanmakuWithCompletionHandler:^(id<VideoModelProtocol>videoModel, NSError *error) {
        if (!error) {
            [self reloadVideoModel];
        }
    }];
}

- (void)clickDanMuControllerButton:(NSButton *)sender {
    self.playerControlView.rightExpansion = !self.playerControlView.rightExpansion;
}

- (void)clickPlayListViewButton:(NSButton *)sender {
    self.playerControlView.leftExpansion = !self.playerControlView.leftExpansion;
}

- (IBAction)clickStopButton:(NSButton *)sender {
    [self saveCurrentVideoTime];
    [self stopPlay];
    //全屏状态自动退出
    if (_fullScreen) [self toggleFullScreen];
    [self.presentingViewController dismissViewController:self];
}

- (void)clickVolumeSlider:(NSSlider *)sender {
    [self volumeValueAddTo:sender.floatValue];
}

//控制是否隐藏/显示弹幕
- (IBAction)clickDanmakuShowButton:(NSButton *)sender {
    self.playDanmakuShowButton.state = sender.state;
}

- (void)clickVolumeButton:(NSButton *)button {
    self.volumeControlView.isHidden ? [self.volumeControlView show] : [self.volumeControlView hide];
}

- (IBAction)clickFullScreenButton:(NSButton *)sender {
    [self toggleFullScreen];
}

- (IBAction)clickDanmakuColorButton:(NSPopUpButton *)sender {
    if (sender.indexOfSelectedItem == 7) {
        NSColorPanel *panel = [NSColorPanel sharedColorPanel];
        [panel setTarget:self];
        [panel orderFront:self];
    }
}

- (IBAction)clickDownloadButton:(NSMenuItem *)sender {
    sender.hidden = YES;
    [self.vm downloadCurrentVideoWithProgress:^(id<VideoModelProtocol> model) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VIDEO_DOWNLOAD_PROGRESS" object:model];
    } completionHandler:^(id<VideoModelProtocol> model, NSURL *downLoadURL, DanDanPlayErrorModel *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_OVER" object:[NSString stringWithFormat:@"%@缓存%@",[model fileName], @"完成"]];
        }
        else {
            sender.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_OVER" object:[NSString stringWithFormat:@"%@缓存%@",[model fileName], @"失败"]];
        }
    }];
}

- (void)launchDanmaku {
    NSString *text = self.danmakuTextField.stringValue;
    if (!text.length) return;
    
    DanmakuModeMenuItem *item = (DanmakuModeMenuItem *)self.danmakuModePopUpButton.selectedItem;
    DanmakuColorMenuItem *colorItem = (DanmakuColorMenuItem *)self.danmakuColorPopUpButton.selectedItem;
    
    NSInteger mode = item.mode;
    NSInteger color = colorItem.itemColor;
    [PlayerMethodManager launchDanmakuWithText:text color:color mode:mode time:self.danmakuEngine.currentTime + self.danmakuEngine.offsetTime episodeId:self.vm.currentVideoModel.episodeId completionHandler:^(DanmakuDataModel *model, NSError *error) {
        //无错误发射
        if (!error) {
            JHBaseDanmaku *danmaku = [JHDanmakuEngine DanmakuWithModel:model shadowStyle:[UserDefaultManager shareUserDefaultManager].danmakuSpecially fontSize:0 font:[UserDefaultManager shareUserDefaultManager].danmakuFont];
            danmaku.appearTime = self.danmakuEngine.currentTime + self.danmakuEngine.offsetTime;
            NSMutableAttributedString *str = [danmaku.attributedString mutableCopy];
            [str addAttributes:@{NSUnderlineColorAttributeName:[NSColor greenColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange(0, str.length)];
            danmaku.attributedString = str;
            self.danmakuTextField.text = nil;
            self.messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLaunchDanmakuSuccess].message;
            [self.messageView showHUD];
            [self.danmakuEngine sendDanmaku: danmaku];
            [self.vm saveUserDanmaku:model];
        }
        else {
            self.messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLaunchDanmakuFail].message;
            [self.messageView showHUD];
        }
    }];
}

#pragma mark -------- 播放控制相关 --------
//结束播放
- (void)stopPlay {
    [self.danmakuEngine stop];
    [self.player stop];
    self.playerControlView.slideView.currentProgress = 0;
    self.playerControlView.slideView.bufferProgress = 0;
    self.timeLabel.text = @"00:00 / 00:00";
}

//更改当前视频
- (void)saveTimeAndChangeCurrentIndex:(NSInteger)index {
    [self saveCurrentVideoTime];
    [self stopPlay];
    self.vm.currentIndex = index;
}

//保存当前视频时间
- (void)saveCurrentVideoTime {
    [[UserDefaultManager shareUserDefaultManager] setVideoPlayHistoryWithHash:self.vm.currentVideoModel.md5 time:[self.player currentTime]];
}

/**
 *  绝对的增加音量
 *
 *  @param addTo 增加到
 */
- (void)volumeValueAddTo:(CGFloat)addTo {
    self.player.volume = addTo;
    self.messageView.text = [NSString stringWithFormat:@"音量: %ld", (long)self.player.volume];
    [self.messageView showHUD];
}

/**
 *  相对的增加音量
 *
 *  @param addBy 增加值
 */
- (void)volumeValueAddBy:(CGFloat)addBy {
    [self.player volumeJump:addBy];
    self.messageView.text = [NSString stringWithFormat:@"音量: %ld", (long)self.player.volume];
    [self.messageView showHUD];
}

#pragma mark 重新加载弹幕 更新进度
- (void)reloadCurrentVideoDanmakuWithCompletionHandler:(void(^)(id<VideoModelProtocol>videoModel, NSError *error))complete {
    
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeAnalyze].message style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(300, 100) fontSize:20 hideWhenClick:NO];
    
    [self.vm reloadDanmakuWithIndex:self.vm.currentIndex completionHandler:^(CGFloat progress, id<VideoModelProtocol> videoModel, DanDanPlayErrorModel *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
                id vm = self.vm.currentVideoModel;
                if ([vm isKindOfClass:[LocalVideoModel class]] && [error isEqual:[DanDanPlayErrorModel errorWithCode:DanDanPlayErrorTypeNoMatchDanmaku]]) {
                    MatchViewController *vc = [MatchViewController viewController];
                    vc.videoModel = (LocalVideoModel *)vm;
                    [self presentViewControllerAsSheet: vc];
                    return;
                }
                self.messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeVideoNoFound].message;
                [self.messageView showHUD];
                complete(videoModel, error);
            }
            else {
                [JHProgressHUD shareProgressHUD].progress = progress;
                if (progress == 0.5) {
                    [JHProgressHUD shareProgressHUD].text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeAnalyzeVideo].message;
                }
                else if (progress == 1) {
                    [JHProgressHUD shareProgressHUD].text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloadingDanmaku].message;
                    [NSUserNotificationCenter postMatchMessageWithMatchName:videoModel.matchTitle delegate:self];
                    [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
                    complete(videoModel, error);
                }
            }
        });
    }];
}

//进入全屏方法
- (void)toggleFullScreen {
    NSWindow *windows = [NSApplication sharedApplication].keyWindow;
    windows.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    [windows toggleFullScreen: nil];
}

#pragma mark 截图
- (void)snapShot {
    NSString *path = [[UserDefaultManager shareUserDefaultManager].screenShotPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %@", self.vm.currentVideoModel.fileName, [self.snapshotFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]]];
    
    [self.player saveVideoSnapshotAt:path withSize:CGSizeZero format:[UserDefaultManager shareUserDefaultManager].defaultScreenShotType completionHandler:^(NSString *savePath, NSError *error) {
        if (error) {
            DanDanPlayMessageModel *model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeSnapshotError];
            [NSUserNotificationCenter postMatchMessageWithTitle:[ToolsManager appName] subtitle:model.message informativeText:model.infomationMessage delegate:self];
        }
        else {
            [NSUserNotificationCenter postMatchMessageWithTitle:[ToolsManager appName] subtitle:@"截图成功" informativeText:nil delegate:self];
        }
    }];
}


#pragma mark -------- view尺寸变化相关 --------

- (void)danmakuCanvasResizeWithAnimate:(BOOL)isAnimate {
    CGRect frame = self.playerHoldView.frame;
    if ([UserDefaultManager shareUserDefaultManager].turnOnCaptionsProtectArea) {
        CGFloat offset = frame.size.height * 0.15;
        frame.origin.y += offset;
        frame.size.height -= offset;
    }
    if (isAnimate) {
        [self.danmakuEngine.canvas pop_addAnimation:[self basicAnimateWithToValue:[NSValue valueWithRect:frame] propertyNamed:kPOPViewFrame] forKey:@"danmaku_canvas_frame_anima"];
    }
    else {
        self.danmakuEngine.canvas.frame = frame;
    }
}

- (void)danmakuCanvasResizeWithAnimate {
    [self danmakuCanvasResizeWithAnimate:YES];
}

#pragma mark -------- 通知 --------
#pragma mark 改变发送弹幕颜色
- (void)changeDanmakuColor:(NSNotification *)sender {
    NSColorPanel *panel = sender.object;
    DanmakuColorMenuItem *item = (DanmakuColorMenuItem *)[self.danmakuColorPopUpButton itemAtIndex:7];
    [item setItemColor:panel.color];
}
#pragma mark 改变发送弹幕字体
- (void)changeDanmakuFont:(NSNotification *)sender {
    self.danmakuEngine.globalFont = sender.userInfo[@"font"];
}

#pragma mark 更改字体边缘特效
- (void)changeFontSpecially:(NSNotification *)sender {
    self.danmakuEngine.globalEffectStyle = [sender.userInfo[@"fontSpecially"] integerValue];
}

#pragma make 窗口大小变化
- (void)windowDidResize:(NSNotification *)notification {
    if (notification.object == NSApp.mainWindow) {
        [self danmakuCanvasResizeWithAnimate:NO];
    }
}

#pragma make 进入全屏通知
- (void)windowWillEnterFullScreen:(NSNotification *)notification {
    _fullScreen = YES;
    [[ToolsManager shareToolsManager] disableSleep];
}

#pragma make 退出全屏通知
- (void)windowWillExitFullScreen:(NSNotification *)notification {
    _fullScreen = NO;
    [_autoHideTimer invalidate];
    [[ToolsManager shareToolsManager] ableSleep];
}


#pragma mark 播放通知
- (void)startPlayNotice:(NSNotification *)sender {
    [self stopPlay];
    NSArray <id<VideoModelProtocol>>*videos = sender.object;
    [self addVideos:videos];
    [self saveTimeAndChangeCurrentIndex:[self.vm.videos indexOfObject:videos.firstObject]];
    
    [self reloadVideoModel];
}

- (void)reloadVideoModel {
    id<VideoModelProtocol>currentVideoModel = self.vm.currentVideoModel;
    [self.player setMediaURL:currentVideoModel.fileURL];
    _danmakuDic = [currentVideoModel danmakuDic];
    self.danmakuEngine.currentTime = self.player.currentTime;
//    [self.danmakuEngine sendAllDanmakusDic:currentVideoModel.danmakuDic];
    [self.playerListViewController.tableView reloadData];
    [self.player videoSizeWithCompletionHandle:^(CGSize size) {
        if (size.width < 0 || size.height < 0) {
            self.messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeVideoNoFound].message;
            [self.messageView showHUD];
            return;
        }
        [self setupWithMediaSize:size];
        [self.player play];
    }];
}


#pragma mark 快捷键调用的方法
- (void)targetMethodWithId:(NSNumber *)Id {
    __weak typeof(self)weakSelf = self;
    switch (Id.integerValue) {
        case 0:
            [self toggleFullScreen];
            break;
        case 1:
            self.playButton.state = !self.playButton.state;
            [self clickPlayButton:self.playButton];
            break;
        case 2:
            [self volumeValueAddBy:-20];
            break;
        case 3:
            [self volumeValueAddBy:20];
            break;
        case 4:
            [self volumeValueAddTo:0];
            break;
        case 5:
        {
            [self.player jump: SHORT_JUMP_TIME completionHandler:^(NSTimeInterval time) {
                weakSelf.danmakuEngine.currentTime = time;
            }];
        }
            break;
        case 6:
        {
            [self.player jump: -SHORT_JUMP_TIME completionHandler:^(NSTimeInterval time) {
                weakSelf.danmakuEngine.currentTime = time;
            }];
            
        }
            break;
        case 7:
        {
            [self.player jump: MEDIUM_JUMP_TIME completionHandler:^(NSTimeInterval time) {
                weakSelf.danmakuEngine.currentTime = time;
            }];
        }
            break;
        case 8:
        {
            [self.player jump: -MEDIUM_JUMP_TIME completionHandler:^(NSTimeInterval time) {
                weakSelf.danmakuEngine.currentTime = time;
            }];
        }
            break;
        case 9:
            [self snapShot];
            break;
        case 10:
            self.playDanmakuShowButton.state = !self.playDanmakuShowButton.state;
            break;
        default:
            break;
    }
}

#pragma mark 其它
- (void)autoHideMouseControlView {
    [NSCursor setHiddenUntilMouseMoves:YES];
    self.playerControlView.status = PlayerControlViewStatusInActive;
    self.controlDanMakuControllerViewButton.animator.alphaValue = 0;
    self.controlPlayListControllerViewButton.animator.alphaValue = 0;
}

- (POPSpringAnimation *)springAnimateWithToValue:(id)value propertyNamed:(NSString *)propertyNamed completionBlock:(void(^)(POPAnimation *, BOOL))completionBlock {
    if (!propertyNamed.length) {
        propertyNamed = kPOPLayoutConstraintConstant;
    }
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:propertyNamed];
    animate.beginTime = CACurrentMediaTime();
    animate.springBounciness = 10;
    animate.toValue = value;
    animate.completionBlock = completionBlock;
    return animate;
}

- (POPBasicAnimation*)basicAnimateWithToValue:(id)value propertyNamed:(NSString *)propertyNamed {
    if (!propertyNamed.length) {
        propertyNamed = kPOPLayoutConstraintConstant;
    }
    POPBasicAnimation *animate = [POPBasicAnimation animationWithPropertyNamed:propertyNamed];
    animate.beginTime = CACurrentMediaTime();
    animate.toValue = value;
    return animate;
}

- (void)addVideos:(NSArray<id<VideoModelProtocol>>*)videos {
    [self.vm addVideosModel:videos];
    self.vm.currentIndex = [self.vm.videos indexOfObject:videos.firstObject];
}

#pragma mark - NSUserNotificationDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    //强制显示
    return YES;
}

#pragma mark - JHMediaPlayerDelegate
- (void)mediaPlayer:(JHMediaPlayer *)player progress:(float)progress formatTime:(NSString *)formatTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新当前时间
        self.timeLabel.text = formatTime;
        self.playerControlView.slideView.currentProgress = progress;
    });
    //  NSLog(@"%f %f", self.player.currentTime, self.rander.currentTime);
}

- (void)mediaPlayer:(JHMediaPlayer *)player bufferTimeProgress:(float)progress onceBufferTime:(float)onceBufferTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerControlView.slideView.bufferProgress = progress;
    });
}

- (void)mediaPlayer:(JHMediaPlayer *)player statusChange:(JHMediaPlayerStatus)status {
    switch (status) {
        case JHMediaPlayerStatusPause:
            [self.danmakuEngine pause];
            self.playButton.state = NSModalResponseCancel;
            break;
        case JHMediaPlayerStatusStop:
            self.playButton.state = NSModalResponseCancel;
            break;
        case JHMediaPlayerStatusPlaying:
            [self.danmakuEngine start];
            self.playButton.state = NSModalResponseOK;
            [self.bufferProgressHUD hideWithCompletion:nil];
            break;
        case JHMediaPlayerStatusBuffering:
            [self.danmakuEngine pause];
            self.playButton.state = NSModalResponseCancel;
            [self.bufferProgressHUD hideWithCompletion:nil anime:NO];
            [self.bufferProgressHUD showWithView:self.view];
        default:
            break;
    }
}

#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView {
    __weak typeof(self)weakSelf = self;
    [self.player setPosition: endValue completionHandler:^(NSTimeInterval time) {
        weakSelf.danmakuEngine.currentTime = time;
    }];
}

- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView {
    __weak typeof(self)weakSelf = self;
    [self.player setPosition: endValue completionHandler:^(NSTimeInterval time) {
        weakSelf.danmakuEngine.currentTime = time;
    }];
}

- (void)playerSliderMoveEnd:(CGPoint)endPoint endValue:(CGFloat)endValue playerSliderView:(PlayerSlideView *)PlayerSliderView {
    CGRect frame = CGRectMake(endPoint.x, PlayerSliderView.frame.origin.y + 10, 60, 34);
    if (frame.origin.x + frame.size.width >= self.view.frame.size.width) {
        self.HUDTimeView.reverse = YES;
        frame.origin.x -= frame.size.width;
    }
    else {
        self.HUDTimeView.reverse = NO;
    }
    self.HUDTimeView.frame = frame;
    NSInteger time = endValue * self.player.length;
    if (time < 0) time = 0;
    [self.HUDTimeView updateMessage:[NSString stringWithFormat:@"%.2ld:%.2ld",time / 60, time % 60]];
}

#pragma mark - JHDanmakuEngineDelegate
- (NSArray <__kindof JHBaseDanmaku*>*)danmakuEngine:(JHDanmakuEngine *)danmakuEngine didSendDanmakuAtTime:(NSUInteger)time {
    return _danmakuDic[@(time)];
}

- (BOOL)danmakuEngine:(JHDanmakuEngine *)danmakuEngine shouldSendDanmaku:(__kindof JHScrollDanmaku *)danmaku {
    if ([self.globalDanmakuFilter containsObject:@(danmaku.direction)]) {
        return NO;
    }
    return YES;
}

#pragma mark - NSMenu
- (void)resetMenuByOpenStreamDic {
    //只有网络视频才显示
    if (![self.vm.currentVideoModel isKindOfClass:[StreamingVideoModel class]]) return;
    //当前播放链接为网络视频说明没下载过 启用下载按钮
    StreamingVideoModel *model = (StreamingVideoModel *)self.vm.currentVideoModel;
    self.downloadVideoMenuItem.hidden = [model.fileURL isFileURL];
    [self.qualityMenuItem.submenu removeAllItems];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger highCount = [model URLsCountWithQuality:StreamingVideoQualityHigh];
    NSInteger lowCount = [model URLsCountWithQuality:StreamingVideoQualityLow];
    if (highCount) {
        [arr addObject:[self menuItemWithTitle:@"良心画质" quality:StreamingVideoQualityHigh]];
    }
    if (lowCount) {
        [arr addObject:[self menuItemWithTitle:@"渣画质" quality:StreamingVideoQualityLow]];
    }
    
    StreamingVideoQuality quality = model.quality;
    NSUInteger openStreamIndex = model.URLIndex;
    for (NSInteger i = 0 ; i < arr.count; ++i) {
        QualityMenuItem *item = arr[i];
        item.state = item.quality == quality;
        //良心画质
        if ([item.title isEqualToString:@"良心画质"]) {
            for (NSInteger i = 0; i < highCount; ++i) {
                NSMenuItem *sitem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"备胎线路 %ld", i + 1] action:@selector(clickItem:) keyEquivalent:@""];
                sitem.tag = 20 + i;
                sitem.state = item.state && openStreamIndex == i;
                [item.submenu addItem:sitem];
            }
        }
        //渣画质
        else {
            for (NSInteger i = 0; i < lowCount; ++i) {
                NSMenuItem *sitem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"备胎线路 %ld", i + 1] action:@selector(clickItem:) keyEquivalent:@""];
                sitem.tag = 10 + i;
                sitem.state = item.state && openStreamIndex == i;
                [item.submenu addItem:sitem];
            }
        }
    }
}

- (QualityMenuItem *)menuItemWithTitle:(NSString *)title quality:(StreamingVideoQuality)quality {
    QualityMenuItem *item = [[QualityMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    item.submenu = [[NSMenu alloc] initWithTitle:item.title];
    [self.qualityMenuItem.submenu addItem:item];
    item.quality = quality;
    return item;
}

- (void)clickItem:(NSMenuItem *)item {
    StreamingVideoQuality quality;
    NSInteger index;
    if (item.tag >= 20) {
        quality = StreamingVideoQualityHigh;
        index = item.tag - 20;
    }
    else {
        quality = StreamingVideoQualityLow;
        index = item.tag - 10;
    }
    
    StreamingVideoModel *model = (StreamingVideoModel *)self.vm.currentVideoModel;
    model.quality = quality;
    model.URLIndex = index;
    
    index = self.vm.currentIndex;
    [self saveTimeAndChangeCurrentIndex:index];
    [self reloadCurrentVideoDanmakuWithCompletionHandler:^(id<VideoModelProtocol>videoModel, NSError *error) {
        if (!error) {
            [self reloadVideoModel];
        }
    }];
}

#pragma mark - 懒加载
- (NSDateFormatter *)formatter {
    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"mm:ss"];
    }
    return _formatter;
}

- (NSDateFormatter *)snapshotFormatter {
    if (_snapshotFormatter == nil) {
        _snapshotFormatter = [[NSDateFormatter alloc] init];
        [_snapshotFormatter setDateFormat:@"YYYY_MM_dd HH_mm_ss"];
    }
    return _snapshotFormatter;
}

- (NSButton *)controlDanMakuControllerViewButton {
    if(_controlDanMakuControllerViewButton == nil) {
        _controlDanMakuControllerViewButton = [[NSButton alloc] init];
        _controlDanMakuControllerViewButton.bordered = NO;
        _controlDanMakuControllerViewButton.bezelStyle = NSTexturedRoundedBezelStyle;
        [_controlDanMakuControllerViewButton setImage: [NSImage imageNamed:@"show_damaku_controller"]];
        [_controlDanMakuControllerViewButton setTarget: self];
        [_controlDanMakuControllerViewButton setAction: @selector(clickDanMuControllerButton:)];
        [self.view addSubview: _controlDanMakuControllerViewButton positioned:NSWindowAbove relativeTo: self.playerControlView];
        [_controlDanMakuControllerViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(100);
            make.centerY.mas_equalTo(0);
            make.right.equalTo(self.playerDanmakuAndSubtitleViewController.view.mas_left);
        }];
    }
    return _controlDanMakuControllerViewButton;
}

- (NSButton *)controlPlayListControllerViewButton {
    if(_controlPlayListControllerViewButton == nil) {
        _controlPlayListControllerViewButton = [[NSButton alloc] init];
        _controlPlayListControllerViewButton.bordered = NO;
        _controlPlayListControllerViewButton.bezelStyle = NSTexturedRoundedBezelStyle;
        
        [_controlPlayListControllerViewButton setImage: [NSImage imageNamed:@"show_play_list_controller"]];
        [_controlPlayListControllerViewButton setTarget: self];
        [_controlPlayListControllerViewButton setAction: @selector(clickPlayListViewButton:)];
        [self.view addSubview: _controlPlayListControllerViewButton positioned:NSWindowAbove relativeTo: self.playerControlView];
        [_controlPlayListControllerViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.centerY.equalTo(self.controlDanMakuControllerViewButton);
            make.left.equalTo(self.playerListViewController.view.mas_right);
        }];
    }
    return _controlPlayListControllerViewButton;
}

- (HUDMessageView *)messageView {
    if(_messageView == nil) {
        _messageView = [[HUDMessageView alloc] init];
        [self.view addSubview: _messageView positioned:NSWindowAbove relativeTo: self.danmakuEngine.canvas];
    }
    return _messageView;
}

- (NSArray *)keyMap {
    if(_keyMap == nil) {
        _keyMap = [UserDefaultManager shareUserDefaultManager].customKeyMapArr;
    }
    return _keyMap;
}

- (JHDanmakuEngine *)danmakuEngine {
    if(_danmakuEngine == nil) {
        _danmakuEngine = [[JHDanmakuEngine alloc] init];
//        _danmakuEngine.turnonBackFunction = YES;
        _danmakuEngine.delegate = self;
        _danmakuEngine.canvas.layoutStyle = JHDanmakuCanvasLayoutStyleWhenSizeChanged;
        [_danmakuEngine setSpeed: [UserDefaultManager shareUserDefaultManager].danmakuSpeed];
        _danmakuEngine.canvas.alphaValue = [UserDefaultManager shareUserDefaultManager].danmakuOpacity;
        [self.view addSubview:_danmakuEngine.canvas positioned:NSWindowAbove relativeTo:self.playerHoldView];
    }
    return _danmakuEngine;
}

- (VolumeControlView *)volumeControlView {
    if(_volumeControlView == nil) {
        _volumeControlView = [[VolumeControlView alloc] init];
        [_volumeControlView.volumeSlider setTarget:self];
        [_volumeControlView.volumeSlider setAction:@selector(clickVolumeSlider:)];
    }
    return _volumeControlView;
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseMoved | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

- (TimeHUDMessageView *)HUDTimeView {
    if(_HUDTimeView == nil) {
        _HUDTimeView = [[TimeHUDMessageView alloc] initWithFrame:CGRectMake(0, self.playerControlView.slideView.frame.origin.y + 10, 60, 34)];
        _HUDTimeView.alphaValue = 0;
    }
    return _HUDTimeView;
}

- (PlayerListViewController *)playerListViewController {
    if(_playerListViewController == nil) {
        __weak typeof(self)weakSelf = self;
        _playerListViewController = [[PlayerListViewController alloc] initWithNibName:@"PlayerListViewController" bundle:nil];
        
        _playerListViewController.vm = self.vm;
        //点击删除
        [_playerListViewController setDeleteRowCallBack:^(NSUInteger row) {
            if (row == weakSelf.vm.currentIndex) {
                [weakSelf clickNextButton:nil];
            }
        }];
        //点击行
        [_playerListViewController setDoubleClickRowCallBack:^(NSUInteger row) {
            [weakSelf saveTimeAndChangeCurrentIndex:row];
            [weakSelf reloadCurrentVideoDanmakuWithCompletionHandler:^(id<VideoModelProtocol>videoModel, NSError *error) {
                if (!error) {
                    [weakSelf reloadVideoModel];
                }
            }];
        }];
        [self addChildViewController:_playerListViewController];
        [self.view addSubview: _playerListViewController.view positioned:NSWindowAbove relativeTo:self.playerControlView];
    }
    return _playerListViewController;
}

- (PlayerDanmakuAndSubtitleViewController *)playerDanmakuAndSubtitleViewController {
    if(_playerDanmakuAndSubtitleViewController == nil) {
        _playerDanmakuAndSubtitleViewController = [[PlayerDanmakuAndSubtitleViewController alloc] init];
        
        __weak typeof(self)weakSelf = self;
        //关闭窗口
        [_playerDanmakuAndSubtitleViewController.danmakuVC setHideDanMuAndCloseCallBack:^(NSInteger num, NSInteger status) {
            if (status) {
                [weakSelf.globalDanmakuFilter addObject:@(num)];
            }
            else {
                [weakSelf.globalDanmakuFilter removeObject:@(num)];
            }
        }];
        //调整弹幕字体大小
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuFontSizeCallBack:^(CGFloat value) {
            weakSelf.danmakuEngine.globalFont = [[NSFontManager sharedFontManager] convertFont:[UserDefaultManager shareUserDefaultManager].danmakuFont toSize:value];
        }];
        //调整弹幕速度
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuSpeedCallBack:^(CGFloat value) {
            [weakSelf.danmakuEngine setSpeed: value];
        }];
        //调整弹幕透明度
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuOpacityCallBack:^(CGFloat value) {
            weakSelf.danmakuEngine.canvas.alphaValue = value;
        }];
        //调整弹幕偏移时间
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuTimeOffsetCallBack:^(NSInteger value) {
            weakSelf.danmakuEngine.offsetTime = value;
            weakSelf.messageView.text = [NSString stringWithFormat:@"弹幕：%@%ld秒", weakSelf.danmakuEngine.offsetTime >= 0 ? @"+" : @"", (long)weakSelf.danmakuEngine.offsetTime];
            [weakSelf.messageView showHUD];
        }];
        //搜索其它弹幕
        [_playerDanmakuAndSubtitleViewController.danmakuVC setShowSearchViewControllerCallBack:^{
            SearchViewController *vc = [SearchViewController viewController];
            vc.searchText = weakSelf.vm.currentVideoModel.fileName;
            [weakSelf presentViewControllerAsSheet: vc];
        }];
        
        //加载本地弹幕
        [_playerDanmakuAndSubtitleViewController.danmakuVC setReloadLocaleDanmakuCallBack:^{
            [PlayerMethodManager loadLocaleDanMuWithBlock:^(NSDictionary *dic) {
                if (dic.count > 0) {
                    __strong typeof(weakSelf)self = weakSelf;
                    self.vm.currentVideoModel.danmakuDic = dic;
//                    [weakSelf.danmakuEngine sendAllDanmakusDic:dic];
                    self->_danmakuDic = dic;
                    self.danmakuEngine.currentTime = self.player.currentTime;
                    weakSelf.danmakuEngine.currentTime = weakSelf.player.currentTime;
                }
                else {
                    [[NSAlert alertWithMessageText:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeCannotLaunchDanmakuFormatterError].message informativeText:nil] runModal];
                }
            }];
        }];
        
        //切换字幕轨道
        [_playerDanmakuAndSubtitleViewController.subtitleVC setTouchSubtitleIndexCallBack:^(int index) {
            weakSelf.player.currentSubtitleIndex = index;
        }];
        //字幕偏移时间
        [_playerDanmakuAndSubtitleViewController.subtitleVC setTimeOffsetCallBack:^(NSInteger value) {
            weakSelf.player.subtitleDelay = value * 1000000;
            weakSelf.messageView.text = [NSString stringWithFormat:@"字幕：%@%ld秒", value >= 0 ? @"+" : @"", value];
            [weakSelf.messageView showHUD];
        }];
        //选择本地字幕
        [_playerDanmakuAndSubtitleViewController.subtitleVC setChooseLoactionFileCallBack:^{
            [PlayerMethodManager loadLocaleSubtitleWithBlock:^(NSString *path) {
                [weakSelf.player openVideoSubTitlesFromFile:path];
            }];
        }];
        
        [self addChildViewController:_playerDanmakuAndSubtitleViewController];
        [self.view addSubview: _playerDanmakuAndSubtitleViewController.view positioned:NSWindowAbove relativeTo:self.playerControlView];
    }
    return _playerDanmakuAndSubtitleViewController;
}

- (PlayViewModel *)vm {
    if(_vm == nil) {
        _vm = [[PlayViewModel alloc] init];
    }
    return _vm;
}

- (JHProgressHUD *)bufferProgressHUD {
    if(_bufferProgressHUD == nil) {
        _bufferProgressHUD = [[JHProgressHUD alloc] init];
        _bufferProgressHUD.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeVideoBuffering].message;
        _bufferProgressHUD.indicatorColor = DDPRGBColor(255, 255, 255);
    }
    return _bufferProgressHUD;
}

- (NSMutableSet<NSNumber *> *)globalDanmakuFilter {
    if (_globalDanmakuFilter == nil) {
        _globalDanmakuFilter = [NSMutableSet set];
    }
    return _globalDanmakuFilter;
}

@end
