//
//  PlayerViewController.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "MainViewController.h"
#import "MatchViewController.h"
#import "PlayerHUDControl.h"
#import "PlayerSlideView.h"
#import "OpacityScrollView.h"
#import "ColorButton.h"
#import "PlayViewModel.h"
#import "DanMuModel.h"
#import "BarrageCanvas.h"
#import "BarrageDescriptor+Tools.h"
#import "VLCMedia+Tools.h"
#import <VLCKit/VLCKit.h>

@interface PlayerViewController ()<PlayerSlideViewDelegate, NSWindowDelegate>

//非全屏状态面板
@property (weak) IBOutlet NSView *playerControl;
@property (weak) IBOutlet PlayerSlideView *progressSliderView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSSlider *volumeSliderView;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSLayoutConstraint *playerUIHeight;
@property (weak) IBOutlet NSView *playerHoldView;
@property (strong, nonatomic) NSTextField *matchTextField;

//hud面板
@property (strong) IBOutlet PlayerHUDControl *playerHUDControl;
@property (weak) IBOutlet NSTextField *playerHUDCurrentTimeLabel;
@property (weak) IBOutlet NSTextField *playerHUDVideoTimeLabel;
@property (weak) IBOutlet NSSlider *playerHUDProgressSliderView;
@property (weak) IBOutlet NSTextField *videoTitleLabel;
@property (weak) IBOutlet NSSlider *playerVolumeSlider;
@property (weak) IBOutlet NSButton *playHUDButton;


//全屏模式和非全屏模式都存在
@property (strong) IBOutlet OpacityScrollView *danMaKuControllerView;
@property (weak) IBOutlet ColorButton *hideDanMuControllerViewButton;
@property (strong, nonatomic) NSButton *showDanMuControllerViewButton;
@property (weak) IBOutlet NSTextField *fontScaleTextField;
@property (weak) IBOutlet NSTextField *speedAdjustTextField;
@property (weak) IBOutlet NSTextField *danMuOpacityTextField;

@property (strong, nonatomic) VLCVideoView *playerView;
@property (nonatomic, strong) VLCMediaPlayer *player;
@property (strong, nonatomic) VLCMediaListPlayer *listPlayer;
@property (nonatomic, strong) BarrageRenderer *rander;

@property (strong, nonatomic) PlayViewModel *vm;
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) NSDateFormatter *formatter;
//判断是否处于全屏状态
@property (assign, nonatomic, getter=isFullScreen) BOOL fullScreen;
//跟踪区域
@property (strong, nonatomic) NSTrackingArea *trackingArea;
//视频匹配名称
@property (strong, nonatomic) NSString *matchName;
//弹幕偏移时间
@property (assign, nonatomic) NSInteger danMuOffsetTime;
//字体缩放系数
@property (assign, nonatomic) CGFloat fontScale;
//隐藏弹幕类型
@property (strong, nonatomic) NSMutableSet *shieldDanMuStyle;

@property (assign, nonatomic) DanMaKuSpiritEdgeStyle edgeStyle;
@end

@implementation PlayerViewController
#pragma mark - 方法
- (instancetype)initWithLocaleVideos:(NSArray *)localVideoModels danMuDic:(NSDictionary *)dic matchName:(NSString *)matchName{
    if (self = [super initWithNibName: @"PlayerViewController" bundle: nil]) {
        self.vm = [[PlayViewModel alloc] initWithLocalVideoModels:localVideoModels danMuDic: dic];
        self.matchName = matchName;
        self.edgeStyle = DanMaKuSpiritEdgeStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //kvo监听时间变化 用于更新时间面板和进度条
    [self addObserver:self forKeyPath:@"player.time" options:NSKeyValueObservingOptionNew context: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanMuDic:) name:@"danMuChooseOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMathchVideoName:) name:@"mathchVideo" object: nil];
    self.vm.currentIndex = 0;
    [self.vm currentVLCMediaWithCompletionHandler:^(VLCMedia *responseObj) {
        //初始化播放器相关参数
        [self setUpWithMedia: responseObj];
        [self startPlay];
    }]; 
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [self.timer invalidate];
    [self.rander stop];
    [self.player stop];
    [self removeObserver:self forKeyPath:@"player.time"];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id > *)change context:(void *)context{
    CGFloat currentTime = [self currentSecond];
    CGFloat videoTime = [self videoTime];
    
    if(self.player.state == VLCMediaPlayerStatePlaying || self.player.state == VLCMediaPlayerStateBuffering){
        
        //更新当前时间
        if (!self.isFullScreen) {
            self.timeLabel.stringValue = [NSString stringWithFormat:@"%@ / %@", [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:currentTime]], [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]]];
            [self.progressSliderView updateCurrentTime:currentTime / videoTime];
        }else if(self.playerHUDControl.alphaValue){
            self.playerHUDVideoTimeLabel.stringValue = [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]];
            self.playerHUDCurrentTimeLabel.stringValue = [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:currentTime]];
            self.playerHUDProgressSliderView.floatValue = currentTime / videoTime * 100;
        }
    }
}

//全屏
- (void)mouseDown:(NSEvent *)theEvent{
    if (theEvent.clickCount == 2) {
        [self toggleFullScreen];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent{
    NSPoint point = theEvent.locationInWindow;
    if (point.y < 10 && self.isFullScreen){
        [self hideHUDPanelAndCursor];
    }else{
        [self showHUDPanelAndCursor];
    }
    
    if (point.x > self.view.frame.size.width - 50) {
        [self showDanMuControllerButton];
    }else{
        [self hideDanMuControllerButton];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent{
    [self volumeValueAddTo:0 addBy: theEvent.scrollingDeltaY];
}

- (IBAction)clickPlayButton:(NSButton *)sender {
    self.player.state == VLCMediaPlayerStateStopped?[self startPlay]:sender.state?[self videoAndDanMuPlay]:[self videoAndDanMuPause];
    self.playButton.state = sender.state;
    self.playHUDButton.state = sender.state;
}

- (IBAction)clickNextButton:(NSButton *)sender {
    self.vm.currentIndex += 1;
    [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: [self.vm currentLocalVideoModel]]];
}
- (IBAction)clickPreButton:(NSButton *)sender {
    self.vm.currentIndex -= 1;
    [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: [self.vm currentLocalVideoModel]]];
}
- (IBAction)clickHideDanMuContorllerViewButton:(NSButton *)sender {
    [self hideDanMuControllerView];
    [self showDanMuControllerButton];
}

- (void)clickShowDanMuControllerButton:(NSButton *)button{
    [self showDanMuControllerView];
    [self hideDanMuControllerButton];
}

- (IBAction)clickStopButton:(NSButton *)sender {
    [self stopPlay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playOver" object: nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (IBAction)clickVolumeSlider:(NSSlider *)sender {
    [self volumeValueAddTo:sender.intValue addBy:0];
}

- (IBAction)clickFullScreenButton:(NSButton *)sender {
    [self toggleFullScreen];
}

- (IBAction)clickPlayerHUDProgressSliderView:(NSSlider *)sender {
    [self.player setPosition: sender.floatValue / 100];
}
- (IBAction)shieldDanMu:(NSButton *)sender {
    NSNumber *num = @(sender.tag - 200);
    if ([self.shieldDanMuStyle containsObject: num]){
        [self.shieldDanMuStyle removeObject: num];
    }else{
        [self.shieldDanMuStyle addObject: num];
    }
}

- (IBAction)offsetDanMuTime:(NSButton *)sender {
    self.danMuOffsetTime = sender.tag - 100;
}

- (IBAction)danMuOpacity:(NSSlider *)sender {
    //0 ~ 1 默认1
    CGFloat alphaValue = sender.floatValue / 100;
    self.rander.view.alphaValue = alphaValue;
    self.danMuOpacityTextField.stringValue = [NSString stringWithFormat:@"%.1f", alphaValue];
}

- (IBAction)danMuSpeed:(NSSlider *)sender {
    //0.1 ~ 3 默认1
    CGFloat speed = sender.floatValue * 0.029 + 0.1;
    [self.rander setSpeed: speed];
    self.speedAdjustTextField.stringValue = [NSString stringWithFormat:@"%.1f", speed];
}

- (IBAction)danMuFontSize:(NSSlider *)sender {
    //scale: 0.4 ~ 2 默认1
    CGFloat fontScale = sender.floatValue * 0.016 + 0.4;
    self.fontScale = fontScale;
    self.fontScaleTextField.stringValue = [NSString stringWithFormat:@"%.1f", fontScale];
}



#pragma mark - 私有方法

//进入全屏方法
- (void)toggleFullScreen{
    NSWindow *windows = [NSApplication sharedApplication].keyWindow;
    windows.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    [windows toggleFullScreen: nil];
}



//进入全屏通知
- (void)windowWillEnterFullScreen:(NSNotification *)notification{
    self.playerUIHeight.constant = 0;
    self.fullScreen = YES;
    self.playerHUDControl.hidden = NO;
}

//退出全屏通知
- (void)windowWillExitFullScreen:(NSNotification *)notification{
    self.playerUIHeight.constant = 40;
    self.fullScreen = NO;
    self.playerHUDControl.hidden = YES;
    [NSCursor unhide];
}

- (void)changeDanMuDic:(NSNotification *)notification{
    [self.vm currentVLCMediaWithCompletionHandler:^(VLCMedia *responseObj) {
        [self stopPlay];
        [self setUpWithMedia: responseObj];
        self.vm.dic = notification.userInfo;
        [self startPlay];
    }];
}

- (void)changeMathchVideoName:(NSNotification *)notification{
    self.videoTitleLabel.stringValue = notification.userInfo[@"animateTitle"];
}

//开始播放
- (void)startPlay{
    [self videoAndDanMuPlay];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(startTimer) userInfo: nil repeats: YES];
}
//结束播放
- (void)stopPlay{
    [self.rander stop];
    [self.listPlayer stop];
    self.playButton.state = 1;
    self.playHUDButton.state = 1;
    [self.progressSliderView updateCurrentTime: 0];
    [self.playerHUDProgressSliderView setFloatValue: 0];
    
    self.timeLabel.stringValue = @"00:00 / 00:00";
    self.playerHUDVideoTimeLabel.stringValue = @"00:00";
    self.playerHUDCurrentTimeLabel.stringValue = @"00:00";
    [NSApplication sharedApplication].mainWindow.title = @"弹弹play";
    [self.timer invalidate];
}

//播放弹幕和视频
- (void)videoAndDanMuPlay{
    [self.rander start];
    [self.listPlayer play];
}

//暂停弹幕和视频
- (void)videoAndDanMuPause{
    [self.rander pause];
    [self.listPlayer pause];
}

//启动计时器
- (void)startTimer{
    //暂停状态直接返回
    if (self.player.state == VLCMediaPlayerStatePaused) return;
    //播放弹幕
    NSArray* danMus = [self.vm currentSecondDanMuArr: [self currentSecond] + self.danMuOffsetTime];
    [danMus enumerateObjectsUsingBlock:^(DanMuDataModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.shieldDanMuStyle containsObject: @(obj.mode)]) {
            [self.rander receive: [BarrageDescriptor descriptorWithText:obj.message color:obj.color spiritStyle:obj.mode edgeStyle:self.edgeStyle fontSize: obj.fontSize * self.fontScale]];
        }
    }];

}
//视频当前播放时间
- (CGFloat)currentSecond{
    return self.player.time.numberValue.floatValue / 1000;
}
//视频总时长
- (CGFloat)videoTime{
    return self.player.media.length.numberValue.floatValue / 1000;
}
//显示hud面板
- (void)showHUDPanelAndCursor{
    [NSCursor unhide];
    self.playerHUDControl.animator.alphaValue = 1;
}

//隐藏hud面板
- (void)hideHUDPanelAndCursor{
    [NSCursor hide];
    self.playerHUDControl.animator.alphaValue = 0;
}
//显示弹幕控制面板
- (void)showDanMuControllerView{
    NSRect rect = NSMakeRect(self.view.frame.size.width - 250, self.playerControl.frame.size.height, 250, self.view.frame.size.height - self.playerControl.frame.size.height);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        self.danMaKuControllerView.animator.frame = rect;
        self.showDanMuControllerViewButton.hidden = YES;
    } completionHandler:nil];
}
//隐藏弹幕控制面板
- (void)hideDanMuControllerView{
    NSRect rect = NSMakeRect(self.view.frame.size.width, self.playerControl.frame.size.height, 250, self.view.frame.size.height - self.playerControl.frame.size.height);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        self.danMaKuControllerView.animator.frame = rect;
        self.showDanMuControllerViewButton.hidden = NO;
    } completionHandler:nil];
}

- (void)showDanMuControllerButton{
    self.showDanMuControllerViewButton.animator.alphaValue = 1;
}

- (void)hideDanMuControllerButton{
    self.showDanMuControllerViewButton.animator.alphaValue = 0;
}

//隐藏匹配信息
- (void)hideMatchTextField:(NSTimer *)timer{
    self.matchTextField.animator.alphaValue = 0;
    [timer invalidate];
}

/**
 *  改音量 两个只能一个为零
 *
 *  @param addTo 增加到
 *  @param addBy 增加
 */
- (void)volumeValueAddTo:(CGFloat)addTo addBy:(CGFloat)addBy{
    if (addTo) {
        self.player.audio.volume = addTo * 2;
        self.volumeSliderView.intValue = addTo;
        self.playerVolumeSlider.intValue = addTo;
    }else if (addBy){
        CGFloat volume = self.player.audio.volume;
        volume += addBy;
        volume = (volume < 200)?volume:200;
        self.player.audio.volume = volume;
        self.volumeSliderView.intValue = volume / 2;
        self.playerVolumeSlider.intValue = volume / 2;
    }
}

- (void)setUpWithMedia:(VLCMedia *)aMedia{
    //必须设置 不然弹幕无法显示
    [self.view setWantsLayer: YES];
    
    self.playerHoldView.layer.backgroundColor = [NSColor blackColor].CGColor;
    [self.playerHoldView addSubview:self.playerView];
    
    CGSize videoSize = [aMedia videoSize];
    CGSize screenSize = [NSScreen mainScreen].frame.size;
    
    //当把视频放大到屏幕大小时 如果视频高超过屏幕高 则使用这个约束
    if (screenSize.width * (videoSize.height / videoSize.width) > screenSize.height) {
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.bottom.mas_equalTo(0);
            make.width.equalTo(self.playerView.mas_height).multipliedBy(videoSize.width / videoSize.height);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
        }];
    //没超过 使用这个约束
    }else{
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.height.equalTo(self.playerView.mas_width).multipliedBy(videoSize.height / videoSize.width);
        }];
    }
    
    //初始化视频信息
    self.listPlayer.rootMedia = aMedia;
    //设置HUD面板属性
    [self.view addSubview: self.playerHUDControl];
    [self.playerHUDControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(500);
        make.height.mas_equalTo(100);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-200);
    }];
    self.playerHUDControl.hidden = !self.isFullScreen;
    //设置非全屏状态面板
    self.playerControl.layer.backgroundColor = [NSColor windowFrameColor].CGColor;
    self.progressSliderView.delegate = self;
    self.videoTitleLabel.stringValue = [self.vm currentVideoName];
    
    //设置弹幕控制视图
    [self.hideDanMuControllerViewButton setTitleColor: [NSColor whiteColor]];
    
    [self.view addSubview: self.danMaKuControllerView];
    [self.danMaKuControllerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.playerControl.mas_top);
        make.left.equalTo(self.view.mas_right);
        make.width.mas_equalTo(250);
    }];
    
    [self.view addSubview: self.showDanMuControllerViewButton positioned:NSWindowAbove relativeTo: self.rander.view];
    [self.showDanMuControllerViewButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(100);
        make.right.centerY.mas_equalTo(0);
    }];
    
    //设置其它参数
    self.matchTextField.stringValue = self.matchName?[NSString stringWithFormat:@"视频自动匹配为 %@", self.matchName]:@"并没有匹配到视频";
    self.matchTextField.alphaValue = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:5 target: self selector:@selector(hideMatchTextField:) userInfo:nil repeats: NO];
    
    [NSApplication sharedApplication].mainWindow.title = [self.vm currentVideoName];
    [self.view addTrackingArea:self.trackingArea];
    //初始化音量
    self.player.audio.volume = self.volumeSliderView.intValue * 2;
    self.playerVolumeSlider.intValue = self.volumeSliderView.intValue;
    self.player.libraryInstance.debugLogging = NO;
    self.fontScale = 1;
}

#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.player setPosition: endValue];
}
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.player setPosition: endValue];
}

#pragma mark - 懒加载
- (BarrageRenderer *)rander {
    if(_rander == nil) {
        _rander = [[BarrageRenderer alloc] init];
        [_rander setSpeed: 1];
        [self.view addSubview:_rander.view positioned:NSWindowAbove relativeTo:self.playerView];
        [_rander.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.equalTo(self.playerControl.mas_top).mas_offset(-40);
        }];
    }
    return _rander;
}

- (VLCVideoView *)playerView {
    if(_playerView == nil) {
        _playerView = [[VLCVideoView alloc] initWithFrame: NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _playerView;
}

- (NSDateFormatter *)formatter {
    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"mm:ss"];
    }
    return _formatter;
}

- (NSTrackingArea *)trackingArea {
	if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:[NSScreen mainScreen].frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseMoved | NSTrackingInVisibleRect owner:self userInfo:nil];
	}
	return _trackingArea;
}

- (NSTextField *)matchTextField {
	if(_matchTextField == nil) {
		_matchTextField = [[NSTextField alloc] init];
        _matchTextField.editable = NO;
        _matchTextField.font = [NSFont systemFontOfSize: 25];
        _matchTextField.textColor = [NSColor whiteColor];
        _matchTextField.bordered = NO;
        _matchTextField.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.view addSubview: _matchTextField positioned:NSWindowAbove relativeTo: self.rander.view];
        [_matchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
	}
	return _matchTextField;
}


- (NSButton *)showDanMuControllerViewButton {
	if(_showDanMuControllerViewButton == nil) {
		_showDanMuControllerViewButton = [[NSButton alloc] init];
        _showDanMuControllerViewButton.bordered = NO;
        _showDanMuControllerViewButton.bezelStyle = NSTexturedRoundedBezelStyle;
        [_showDanMuControllerViewButton setImage: [NSImage imageNamed:@"showDanMuController"]];
        [_showDanMuControllerViewButton setTarget: self];
        [_showDanMuControllerViewButton setAction: @selector(clickShowDanMuControllerButton:)];
	}
	return _showDanMuControllerViewButton;
}

- (NSMutableSet *)shieldDanMuStyle {
	if(_shieldDanMuStyle == nil) {
		_shieldDanMuStyle = [[NSMutableSet alloc] init];
	}
	return _shieldDanMuStyle;
}

- (VLCMediaListPlayer *)listPlayer {
	if(_listPlayer == nil) {
		_listPlayer = [[VLCMediaListPlayer alloc] initWithDrawable: self.playerView];
	}
	return _listPlayer;
}

- (VLCMediaPlayer *)player {
	return self.listPlayer.mediaPlayer;
}

@end
