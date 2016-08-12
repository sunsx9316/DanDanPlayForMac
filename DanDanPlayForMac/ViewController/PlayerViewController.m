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


@interface PlayerViewController ()<PlayerSlideViewDelegate, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSUserNotificationCenterDelegate, JHMediaPlayerDelegate>

//放视频的 view
@property (weak) IBOutlet PlayerHoldView *playerHoldView;

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

//弹幕和字幕控制器
@property (strong, nonatomic) PlayerDanmakuAndSubtitleViewController *playerDanmakuAndSubtitleViewController;
//播放列表控制器
@property (strong, nonatomic) PlayerListViewController *playerListViewController;

//上次播放时间的view
@property (strong) IBOutlet PlayerLastWatchVideoTimeView *lastWatchVideoTimeView;
//弹幕数view
@property (strong) IBOutlet PlayerDanmakuCountView *danmakuCountView;

//右键显示的清晰度菜单
@property (strong) IBOutlet NSMenu *rightClickMenu;
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
@property (strong, nonatomic) PlayViewModel *vm;
//快捷键映射
@property (strong, nonatomic) NSArray *keyMap;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end

@implementation PlayerViewController
{
    //是否处于全屏状态
    BOOL _fullScreen;
    //判断用户是否点击了暂停
    BOOL _userPause;
    //时间格式化工具
    NSDateFormatter *_formatter;
    NSDateFormatter *_snapshotFormatter;
    NSTimer *_autoHideTimer;
}

- (instancetype)initWithVideos:(NSArray *)videoModels danMuDic:(NSDictionary *)dic matchName:(NSString *)matchName episodeId:(NSString *)episodeId {
    if (self = [super initWithNibName: @"PlayerViewController" bundle: nil]) {
        self.vm = [[PlayViewModel alloc] initWithVideoModels:videoModels danMuDic:dic episodeId:episodeId];
        [PlayerMethodManager postMatchMessageWithMatchName:matchName delegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuColor:) name:NSColorPanelColorDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuDic:) name:@"DANMAKU_CHOOSE_OVER" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openStreamVCChooseOver:) name:@"OPEN_STREAM_VC_CHOOSE_OVER" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFontSpecially:) name:@"CHANGE_FONT_SPECIALLY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuFont:) name:@"CHANGE_DANMAKU_FONT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(danmakuCanvasResizeWithAnimate) name:@"CHANGE_CAPTIONS_PROTECT_AREA" object:nil];
    
    //初始化播放器相关参数
    [self setupOnce];
    [self.player videoSizeWithCompletionHandle:^(CGSize size) {
        if (size.width < 0 || size.height < 0) {
            self.messageView.text = [UserDefaultManager alertMessageWithKey:@"kVideoNoFoundString"];
            [self.messageView showHUD];
            return;
        }
        [self setupWithMediaSize:size];
        [self startPlay];
    }];
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"volume"];
    [self.playDanmakuShowButton removeObserver:self forKeyPath:@"state"];
    [self.view removeTrackingArea:self.trackingArea];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [NSApplication sharedApplication].mainWindow.title = @"弹弹play";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_OVER" object: nil];
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
    
    _autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoHideMouseControlView) userInfo:nil repeats:NO];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    if (self.player.mediaType == JHMediaTypeNetMedia) {
        [NSMenu popUpContextMenu:self.rightClickMenu withEvent:theEvent forView:self.view];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    int code = theEvent.keyCode;
    NSArray *arr = self.keyMap;
    for (NSDictionary *dic in arr) {
        if ([dic[@"keyCode"] intValue] == code && [dic[@"flag"] unsignedIntegerValue] == flags) {
            [self targetMethodWithID:dic[@"id"]];
            break;
        }
    }
}
//滚轮调整音量
- (void)scrollWheel:(NSEvent *)theEvent {
    //判断是否为apple的破鼠标
    if (theEvent.hasPreciseScrollingDeltas) {
        [self volumeValueAddBy:-theEvent.deltaY];
    }
    else {
        [self volumeValueAddBy:theEvent.scrollingDeltaY];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"volume"]) {
        self.volumeControlView.volumeSlider.floatValue = [change[@"new"] floatValue];
    }
    else if ([keyPath isEqualToString:@"state"]) {
        self.danmakuEngine.canvas.animator.hidden = [change[@"new"] intValue];
    }
}

#pragma mark - 私有方法

#pragma mark -------- 初始化相关 --------
//只需要初始化一次的属性
- (void)setupOnce {
    __weak typeof(self)weakSelf = self;
    
    //必须设置 不然弹幕无法显示
    [self.view setWantsLayer: YES];
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
    [self.playerHoldView setFilePickBlock:^(NSArray *filePaths) {
        if (filePaths.count > 0) {
            NSInteger oldCount = [weakSelf.vm videoCount];
            [weakSelf.vm addVideosModel:filePaths];
            [weakSelf changeCurrentIndex:oldCount];
            [weakSelf reloadDanmakuWithIndex:oldCount];
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
    self.player = [[JHMediaPlayer alloc] initWithMediaURL:[self.vm currentVideoURL]];
    self.player.delegate = self;
    [self.playerHoldView addSubview:self.player.mediaView];
    
    //音量
    [self.view addSubview:self.volumeControlView positioned:NSWindowAbove relativeTo:self.playerControlView];
    [self.player addObserver:self forKeyPath:@"volume" options:NSKeyValueObservingOptionNew context:nil];
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
    [self.playDanmakuShowButton addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    //时间缩略图
    [self.view addSubview:self.HUDTimeView positioned:NSWindowAbove relativeTo:self.playerControlView];
    [self.view addTrackingArea:self.trackingArea];
    
}

- (void)setupWithMediaSize:(CGSize)aMediaSize {
    //重设mediaView的约束
    [PlayerMethodManager remakeConstraintsPlayerMediaView:self.player.mediaView size:aMediaSize];
    
    //设置其它参数
    [NSApplication sharedApplication].keyWindow.title = [self.vm currentVideoName];
    [NSApplication sharedApplication].mainWindow.title = [self.vm currentVideoName];
    //    _danMuOffsetTime = 0;
    _userPause = NO;
    self.playerControlView.status = PlayerControlViewStatusHalfActive;
    //只有官方弹幕库启用发送弹幕功能
    if (!self.vm.episodeId.length) {
        self.danmakuTextField.enabled = NO;
        self.danmakuTextField.placeholderString = [UserDefaultManager alertMessageWithKey:@"kCannotLaunchDanmakuPlaceHoldString"];
    }
    else {
        self.danmakuTextField.enabled = YES;
        self.danmakuTextField.placeholderString = [UserDefaultManager alertMessageWithKey:@"kCanLaunchDanmakuPlaceHoldString"];
    }
    //重设右键菜单
    [self resetMenuByOpenStreamDic];
    //显示上次播放进度
    NSUInteger intTime = [self.vm currentVideoLastVideoTime];
    if (intTime > 0) {
        self.lastWatchVideoTimeView.videoTimeTextField.stringValue = [NSString stringWithFormat:@"上次播放时间: %.2ld:%.2ld",intTime / 60, intTime % 60];
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
        [self startPlay];
        _userPause = NO;
    }
    else if (sender.state) {
        [self videoAndDanMuPlay];
        _userPause = NO;
    }
    else {
        [self videoAndDanMuPause];
        _userPause = YES;
    }
}

- (IBAction)clickNextButton:(NSButton *)sender {
    [self changeCurrentIndex:self.vm.currentIndex + 1];
    [self reloadDanmakuWithIndex:self.vm.currentIndex];
}

- (IBAction)clickPreButton:(NSButton *)sender {
    [self changeCurrentIndex:self.vm.currentIndex - 1];
    [self reloadDanmakuWithIndex:self.vm.currentIndex];
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
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
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

//- (IBAction)clickClearAllHistoryButton:(NSButton *)sender {
//    [self.vm removeVideoAtIndex:-1];
//    [self.playerListTableView reloadData];
//}


- (void)launchDanmaku {
    NSString *text = self.danmakuTextField.stringValue;
    if (!text.length) return;
    
    DanmakuModeMenuItem *item = (DanmakuModeMenuItem *)self.danmakuModePopUpButton.selectedItem;
    DanmakuColorMenuItem *colorItem = (DanmakuColorMenuItem *)self.danmakuColorPopUpButton.selectedItem;
    
    NSInteger mode = item.mode;
    NSInteger color = colorItem.itemColor;
    [PlayerMethodManager launchDanmakuWithText:text color:color mode:mode time:self.danmakuEngine.currentTime + self.danmakuEngine.offsetTime episodeId:self.vm.episodeId completionHandler:^(DanMuDataModel *model, NSError *error) {
        //无错误发射
        if (!error) {
            ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithModel:model shadowStyle:[UserDefaultManager danMufontSpecially] fontSize:0 font:[UserDefaultManager danMuFont]];
            danmaku.appearTime = self.danmakuEngine.currentTime + self.danmakuEngine.offsetTime;
            NSMutableAttributedString *str = [danmaku.attributedString mutableCopy];
            [str addAttributes:@{NSUnderlineColorAttributeName:[NSColor greenColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange(0, str.length)];
            danmaku.attributedString = str;
            self.danmakuTextField.stringValue = @"";
            self.messageView.text = [UserDefaultManager alertMessageWithKey:@"kLaunchDanmakuSuccessString"];
            [self.messageView showHUD];
            [self.danmakuEngine addDanmaku: danmaku];
            [self.vm saveUserDanmaku:model];
        }
        else {
            self.messageView.text = [UserDefaultManager alertMessageWithKey:@"kLaunchDanmakuFailString"];
            [self.messageView showHUD];
        }
    }];
}

#pragma mark -------- 播放控制相关 --------
//开始播放
- (void)startPlay {
    if (self.player.mediaType == JHMediaTypeNetMedia) {
        if (![self.vm currentVideoURL]) {
            [self videoAndDanMuPlay];
            [self videoAndDanMuPause];
        }
    }
    else {
        [self videoAndDanMuPlay];
    }
}

//结束播放
- (void)stopPlay {
    [self.danmakuEngine stop];
    [self.player stop];
    
    [self.playerControlView.slideView updateBufferProgress:0];
    [self.playerControlView.slideView updateCurrentProgress:0];
    self.timeLabel.stringValue = @"00:00 / 00:00";
}

//更改当前视频
- (void)changeCurrentIndex:(NSInteger)index {
    [self saveCurrentVideoTime];
    [self stopPlay];
    self.vm.currentIndex = index;
}

//保存当前视频时间
- (void)saveCurrentVideoTime {
    [UserDefaultManager setVideoPlayHistoryWithHash:[self.vm currentVideoHash] time:[self.player currentTime]];
}

//播放弹幕和视频
- (void)videoAndDanMuPlay {
    [self.danmakuEngine start];
    [self.player play];
}

//暂停弹幕和视频
- (void)videoAndDanMuPause {
    [self.danmakuEngine pause];
    [self.player pause];
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

//- (void)loadLocaleDanMaku {
//    [PlayerMethodManager loadLocaleDanMuWithBlock:^(NSDictionary *dic) {
//        if (dic.count > 0) {
//            self.vm.danmakusDic = dic;
//            [self.danmakuEngine addAllDanmakusDic:dic];
//            [self.player setPosition:0 completionHandler:nil];
//        }
//        else {
//            [[NSAlert alertWithMessageText:kNoFoundDanmakuString informativeText:nil] runModal];
//        }
//    }];
//}

#pragma mark 重新加载弹幕 更新进度
- (void)reloadDanmakuWithIndex:(NSInteger)index {
    [JHProgressHUD showWithMessage:[UserDefaultManager alertMessageWithKey:@"kAnalyzeString"] style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(300, 100) fontSize: 20 dismissWhenClick: NO];
    
    [self.vm reloadDanmakuWithIndex:index completionHandler:^(CGFloat progress, NSString *videoMatchName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [JHProgressHUD disMiss];
                id vm = [self.vm videoModelWithIndex:index];
                if ([vm isKindOfClass:[LocalVideoModel class]] && [error isEqual:kNoMatchError]) {
                    [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: (LocalVideoModel *)vm]];
                    return;
                }
                 self.messageView.text = [UserDefaultManager alertMessageWithKey:@"kVideoNoFoundString"];
                [self.messageView showHUD];
            }
            else {
                [JHProgressHUD updateProgress:progress];
                if (progress == 0.5) {
                    [JHProgressHUD updateMessage:[UserDefaultManager alertMessageWithKey:@"kAnalyzeVideoString"]];
                }
                else if (progress == 1) {
                    [JHProgressHUD updateMessage:[UserDefaultManager alertMessageWithKey:@"kDownLoadingDanmakuString"]];
                    [PlayerMethodManager postMatchMessageWithMatchName:videoMatchName delegate:self];
                    [JHProgressHUD disMiss];
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
    [self.player saveVideoSnapshotAt:[[UserDefaultManager screenShotPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %@", [self.vm currentVideoName], [self.snapshotFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]]] withSize:CGSizeZero format:[UserDefaultManager defaultScreenShotType]];
}


#pragma mark -------- view尺寸变化相关 --------

- (void)danmakuCanvasResizeWithAnimate:(BOOL)isAnimate {
    CGRect frame = self.playerHoldView.frame;
    if ([UserDefaultManager turnOnCaptionsProtectArea]) {
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
#pragma mark 加载网络视频
- (void)openStreamVCChooseOver:(NSNotification *)notification {
    NSArray *arr = notification.userInfo[@"videos"];
    [self.vm addVideosModel:arr];
    //网络视频 episode应该为空
    self.vm.episodeId = nil;
    [self changeCurrentIndex:[self.vm videoCount] - arr.count];
}

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
    self.danmakuEngine.globalShadowStyle = sender.userInfo[@"fontSpecially"];
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
}

#pragma make 退出全屏通知
- (void)windowWillExitFullScreen:(NSNotification *)notification {
    _fullScreen = NO;
    [_autoHideTimer invalidate];
}


#pragma mark 更换弹幕字典通知
- (void)changeDanmakuDic:(NSNotification *)notification {
    [self stopPlay];
    [self.player setMediaURL:[self.vm currentVideoURL]];
    self.vm.danmakusDic = notification.userInfo;
    [self.danmakuEngine addAllDanmakusDic:notification.userInfo];
//    [self.playerListTableView reloadData];
    [self.playerListViewController.tableView reloadData];
    [self.player videoSizeWithCompletionHandle:^(CGSize size) {
        if (size.width < 0 || size.height < 0) {
            self.messageView.text = [UserDefaultManager alertMessageWithKey:@"kVideoNoFoundString"];
            [self.messageView showHUD];
            return;
        }
        [self setupWithMediaSize:size];
        [self startPlay];
    }];
}


#pragma mark 快捷键调用的方法
- (void)targetMethodWithID:(NSNumber *)ID {
    __weak typeof(self)weakSelf = self;
    switch (ID.integerValue) {
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

#pragma mark - NSUserNotificationDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    //强制显示
    return YES;
}

#pragma mark - JHMediaPlayerDelegate
- (void)mediaPlayer:(JHMediaPlayer *)player progress:(float)progress formatTime:(NSString *)formatTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新当前时间
        self.timeLabel.stringValue = formatTime;
        [self.playerControlView.slideView updateCurrentProgress:progress];
    });
    //  NSLog(@"%f %f", self.player.currentTime, self.rander.currentTime);
}

- (void)mediaPlayer:(JHMediaPlayer *)player bufferTimeProgress:(float)progress onceBufferTime:(float)onceBufferTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerControlView.slideView updateBufferProgress:progress];
    });
    if (onceBufferTime > MAX_BUFFER_TIME && self.player.status == JHMediaPlayerStatusPause && !_userPause) {
        [self videoAndDanMuPlay];
    }
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
            break;
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
    }else {
        self.HUDTimeView.reverse = NO;
    }
    self.HUDTimeView.frame = frame;
    NSInteger time = endValue * self.player.length;
    if (time < 0) time = 0;
    [self.HUDTimeView updateMessage:[NSString stringWithFormat:@"%.2ld:%.2ld",time / 60, time % 60]];
}

#pragma mark - NSMenu
- (void)resetMenuByOpenStreamDic {
    //只有网络视频才显示
    if (self.player.mediaType == JHMediaTypeLocaleMedia) return;
    
    [self.rightClickMenu removeAllItems];
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger highCount = [self.vm openStreamCountWithQuality:streamingVideoQualityHigh];
    NSInteger lowCount = [self.vm openStreamCountWithQuality:streamingVideoQualityLow];
    if (highCount) [arr addObject:[self menuItemWithTitle:@"良心画质" quality:streamingVideoQualityHigh]];
    if (lowCount) [arr addObject:[self menuItemWithTitle:@"渣画质" quality:streamingVideoQualityLow]];
    
    streamingVideoQuality quality = [self.vm openStreamQuality];
    NSUInteger openStreamIndex = [self.vm openStreamIndex];
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
        //渣画质
        }
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

- (QualityMenuItem *)menuItemWithTitle:(NSString *)title quality:(streamingVideoQuality)quality {
    QualityMenuItem *item = [[QualityMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    item.submenu = [[NSMenu alloc] initWithTitle:item.title];
    [self.rightClickMenu addItem:item];
    item.quality = quality;
    return item;
}

- (void)clickItem:(NSMenuItem *)item {
    streamingVideoQuality quality;
    NSInteger index;
    if (item.tag >= 20) {
        quality = streamingVideoQualityHigh;
        index = item.tag - 20;
    }
    else {
        quality = streamingVideoQualityLow;
        index = item.tag - 10;
    }
    [self.vm setOpenStreamURLWithQuality: quality index:index];
    [self changeCurrentIndex:self.vm.currentIndex];
    [self reloadDanmakuWithIndex:self.vm.currentIndex];
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
        _controlDanMakuControllerViewButton = [[AddTrackingAreaButton alloc] init];
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
        _controlPlayListControllerViewButton = [[AddTrackingAreaButton alloc] init];
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
        _keyMap = [UserDefaultManager customKeyMap];
    }
    return _keyMap;
}

- (JHDanmakuEngine *)danmakuEngine {
    if(_danmakuEngine == nil) {
        _danmakuEngine = [[JHDanmakuEngine alloc] init];
        _danmakuEngine.turnonBackFunction = YES;
        [_danmakuEngine addAllDanmakusDic:self.vm.danmakusDic];
        [_danmakuEngine setSpeed: [UserDefaultManager danMuSpeed]];
        _danmakuEngine.canvas.alphaValue = [UserDefaultManager danMuOpacity];
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
        [_playerListViewController setDeleteRowCallBack:^(NSUInteger row) {
            if (row == weakSelf.vm.currentIndex) {
                [weakSelf clickNextButton:nil];
            }
        }];
        
        [_playerListViewController setDoubleClickRowCallBack:^(NSUInteger row) {
            [weakSelf changeCurrentIndex:row];
            [weakSelf reloadDanmakuWithIndex:weakSelf.vm.currentIndex];
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
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setHideDanMuAndCloseCallBack:^(NSInteger num, NSInteger status) {
            status ? [weakSelf.danmakuEngine.globalFilterDanmaku addObject:@(num)] : [weakSelf.danmakuEngine.globalFilterDanmaku removeObject:@(num)];
        }];
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuFontSizeCallBack:^(CGFloat value) {
            weakSelf.danmakuEngine.globalFont = [[NSFontManager sharedFontManager] convertFont:[UserDefaultManager danMuFont] toSize:value];
        }];
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuSpeedCallBack:^(CGFloat value) {
            [weakSelf.danmakuEngine setSpeed: value];
        }];
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuOpacityCallBack:^(CGFloat value) {
            weakSelf.danmakuEngine.canvas.alphaValue = value;
        }];
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setAdjustDanmakuTimeOffsetCallBack:^(NSInteger value) {
            weakSelf.danmakuEngine.offsetTime = value;
            weakSelf.messageView.text = [NSString stringWithFormat:@"弹幕：%@%ld秒", weakSelf.danmakuEngine.offsetTime >= 0 ? @"+" : @"", (long)weakSelf.danmakuEngine.offsetTime];
            [weakSelf.messageView showHUD];
        }];
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setShowSearchViewControllerCallBack:^{
            SearchViewController *vc = [[SearchViewController alloc] init];
            vc.searchText = [weakSelf.vm currentVideoName];
            [weakSelf presentViewControllerAsSheet: vc];
        }];
        
        [_playerDanmakuAndSubtitleViewController.danmakuVC setReloadLocaleDanmakuCallBack:^{
            [PlayerMethodManager loadLocaleDanMuWithBlock:^(NSDictionary *dic) {
                if (dic.count > 0) {
                    weakSelf.vm.danmakusDic = dic;
                    [weakSelf.danmakuEngine addAllDanmakusDic:dic];
                }
                else {
                    [[NSAlert alertWithMessageText:[UserDefaultManager alertMessageWithKey:@"kNoFoundDanmakuString"] informativeText:nil] runModal];
                }
            }];
        }];
        
        
        [_playerDanmakuAndSubtitleViewController.subtitleVC setTouchSubtitleIndexCallBack:^(int index) {
            weakSelf.player.currentSubtitleIndex = index;
        }];
        
        [_playerDanmakuAndSubtitleViewController.subtitleVC setTimeOffsetCallBack:^(NSInteger value) {
            weakSelf.player.subtitleDelay = value * 1000000;
            weakSelf.messageView.text = [NSString stringWithFormat:@"字幕：%@%ld秒", value >= 0 ? @"+" : @"", value];
            [weakSelf.messageView showHUD];
        }];
        
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

@end
