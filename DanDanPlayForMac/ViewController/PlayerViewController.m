//
//  PlayerViewController.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "MainViewController.h"

#import "PlayerSlideView.h"
#import "PlayViewModel.h"
#import "DanMuModel.h"
#import "BarrageCanvas.h"
#import "BarrageDescriptor+Tools.h"
#import "JHVLCMedia.h"
#import "VLCMedia+Tools.h"
#import "PlayerHUDControl.h"

#import <VLCKit/VLCKit.h>


#define kHUDPanelHideCount 10
@interface PlayerViewController ()<PlayerSlideViewDelegate, NSWindowDelegate>

//非全屏状态面板
@property (weak) IBOutlet NSView *playerControl;
@property (weak) IBOutlet PlayerSlideView *progressSliderView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSSlider *volumeSliderView;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSLayoutConstraint *playerUIHeight;
@property (weak) IBOutlet NSView *playerHoldView;



//hud面板
@property (strong) IBOutlet PlayerHUDControl *playerHUDControl;
@property (weak) IBOutlet NSTextField *playerHUDCurrentTimeLabel;
@property (weak) IBOutlet NSTextField *playerHUDVideoTimeLabel;
@property (weak) IBOutlet NSSlider *playerHUDProgressSliderView;
@property (weak) IBOutlet NSTextField *videoTitleLabel;
@property (weak) IBOutlet NSSlider *playerVolumeSlider;


@property (strong, nonatomic) VLCVideoView *playerView;
@property (nonatomic, strong) VLCMediaPlayer *player;
@property (nonatomic, strong) BarrageRenderer *rander;

@property (strong, nonatomic) PlayViewModel *vm;
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) VLCMedia *media;
//判断是否处于全屏状态
@property (assign, nonatomic, getter=isFullScreen) BOOL fullScreen;
//用于计数 隐藏hud面板
@property (assign, nonatomic) NSInteger countDown;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end

@implementation PlayerViewController
#pragma mark - 方法
- (instancetype)initWithLocaleVideo:(LocalVideoModel *)localVideoModel vlcMedia:(VLCMedia *)media danMuDic:(NSDictionary *)dic{
    if (self = [super initWithNibName: @"PlayerViewController" bundle: nil]) {
        self.vm = [[PlayViewModel alloc] initWithLocalVideoModel:localVideoModel danMuDic:dic];
        self.media = media;
        self.countDown = kHUDPanelHideCount;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id > *)change context:(void *)context{
    CGFloat currentTime = [self currentSecond];
    CGFloat videoTime = [self videoTime];
    
    if(self.player.state == VLCMediaPlayerStatePlaying || self.player.state == VLCMediaPlayerStateBuffering){
        
        //更新当前时间
        if (!self.isFullScreen) {
            self.timeLabel.stringValue = [NSString stringWithFormat:@"%@ / %@", [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:currentTime]], [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]]];
            [self.progressSliderView updateCurrentTime:currentTime / videoTime];
        }else{
            self.playerHUDVideoTimeLabel.stringValue = [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]];
            self.playerHUDCurrentTimeLabel.stringValue = [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:currentTime]];
            self.playerHUDProgressSliderView.floatValue = currentTime / videoTime * 100;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //kvo监听时间变化 用于更新时间面板和进度条
    [self addObserver:self forKeyPath:@"player.time" options:NSKeyValueObservingOptionNew context: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object: nil];
    
    //初始化播放器相关参数
    [self setUpPlayerConstraintsWithMedia: self.media];
    
    [self startPlay];
    
    self.progressSliderView.delegate = self;
    self.videoTitleLabel.stringValue = [self.vm videoName];
    [NSApplication sharedApplication].mainWindow.title = [self.vm videoName];
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [self.timer invalidate];
    [self.rander stop];
    [self.player stop];
    [self removeObserver:self forKeyPath:@"player.time"];
}

//全屏
- (void)mouseDown:(NSEvent *)theEvent{
    if (theEvent.clickCount == 2) {
        [self toggleFullScreen];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent{
    self.countDown = kHUDPanelHideCount;
    [self showHUDPanelAndCursor];
}

- (IBAction)clickPlayButton:(NSButton *)sender {
    self.player.state == VLCMediaPlayerStateStopped?[self startPlay]:sender.state?[self videoAndDanMuPlay]:[self videoAndDanMuPause];
}
- (IBAction)clickNextButton:(NSButton *)sender {
    
}
- (IBAction)clickPreButton:(NSButton *)sender {
    
}
- (IBAction)clickStopButton:(NSButton *)sender {
    [self stopPlay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playOver" object: nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (IBAction)clickVolumeSlider:(NSSlider *)sender {
    self.player.audio.volume = sender.intValue * 2;
    self.volumeSliderView.intValue = sender.intValue;
    self.playerVolumeSlider.intValue = sender.intValue;
}

- (IBAction)clickFullScreenButton:(NSButton *)sender {
    [self toggleFullScreen];
}

- (IBAction)clickPlayerHUDProgressSliderView:(NSSlider *)sender {
    [self.rander clearAllBarrage];
    [self.player setPosition: sender.floatValue / 100];
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
    [self.view addTrackingArea:self.trackingArea];
}

//退出全屏通知
- (void)windowWillExitFullScreen:(NSNotification *)notification{
    self.playerUIHeight.constant = 40;
    self.fullScreen = NO;
    self.playerHUDControl.hidden = YES;
    [NSCursor unhide];
    [self.view removeTrackingArea:self.trackingArea];
}

//开始播放
- (void)startPlay{
    [self videoAndDanMuPlay];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(startTimer) userInfo: nil repeats: YES];
}
//结束播放
- (void)stopPlay{
    [self.rander stop];
    [self.player stop];
    self.playButton.state = 0;
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
    [self.player play];
}

//暂停弹幕和视频
- (void)videoAndDanMuPause{
    [self.rander pause];
    [self.player pause];
}

//启动计时器
- (void)startTimer{
    //为hud面板计数
    if (self.countDown) self.countDown--;
    else [self hideHUDPanelAndCursor];
    
    //暂停状态直接返回
    if (self.player.state == VLCMediaPlayerStatePaused) return;
    //播放弹幕
    NSArray* danMus = [self.vm currentSecondDanMuArr: [self currentSecond]];
    [danMus enumerateObjectsUsingBlock:^(DanMuDataModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rander receive: [BarrageDescriptor descriptorWithModel: obj]];
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
    //全屏状态 隐藏鼠标才生效
    if (self.isFullScreen) [NSCursor hide];
    self.playerHUDControl.animator.alphaValue = 0;
}

- (void)setUpPlayerConstraintsWithMedia:(VLCMedia *)aMedia{
    //必须设置 不然弹幕无法显示
    [self.view setWantsLayer: YES];
    self.playerHoldView.layer.backgroundColor = [NSColor blackColor].CGColor;
    
    [self.playerHoldView addSubview:self.playerView];
    
    CGSize videoSize = [aMedia videoSize];
    CGSize screenSize = [NSScreen mainScreen].frame.size;
    
    //当把视频放大到屏幕大小时 如果视频高超过屏幕高 则使用这个约束
    if (screenSize.width * (videoSize.height / videoSize.width) > screenSize.height) {
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.bottom.mas_equalTo(0);
            make.width.equalTo(self.playerView.mas_height).multipliedBy(videoSize.width / videoSize.height);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
        }];
    //没超过 使用这个约束
    }else{
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.height.equalTo(self.playerView.mas_width).multipliedBy(videoSize.height / videoSize.width);
        }];
    }
    
    self.player = [[VLCMediaPlayer alloc] initWithVideoView:  self.playerView];
    //初始化视频信息
    self.player.media = self.media;
    //初始化音量
    self.player.audio.volume = self.volumeSliderView.intValue * 2;
    self.playerVolumeSlider.intValue = self.volumeSliderView.intValue;
    self.player.libraryInstance.debugLogging = NO;
    //设置HUD面板属性
    [self.view addSubview: self.playerHUDControl positioned:NSWindowAbove relativeTo: self.rander.view];
    self.playerHUDControl.frame = NSMakeRect([NSScreen mainScreen].frame.size.width / 2 - 250, -200, 500, 100);
    self.playerHUDControl.hidden = YES;
    self.playerControl.layer.backgroundColor = [NSColor windowFrameColor].CGColor;
}

#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.rander clearAllBarrage];
    [self.player setPosition: endValue];
}
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.rander clearAllBarrage];
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

@end
