//
//  PlayerViewController.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerSlideView.h"
#import "PlayViewModel.h"
#import "DanMuModel.h"
#import "BarrageCanvas.h"
#import "BarrageDescriptor+Tools.h"
#import "JHVLCMedia.h"

#import <VLCKit/VLCKit.h>

@interface PlayerViewController ()<PlayerSlideViewDelegate>
@property (weak) IBOutlet NSView *playerUI;
@property (weak) IBOutlet PlayerSlideView *progressSliderView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSSlider *volumeSliderView;

@property (strong, nonatomic) VLCVideoView *playerView;
@property (nonatomic, strong) VLCMediaPlayer *player;
@property (nonatomic, strong) BarrageRenderer *rander;

@property (strong, nonatomic) PlayViewModel *vm;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PlayerViewController
#pragma mark - 方法
- (instancetype)initWithLocaleVideo:(LocalVideoModel *)localVideoModel danMuDic:(NSDictionary *)dic{
    if (self = [super initWithNibName: @"PlayerViewController" bundle: nil]) {
        self.vm = [[PlayViewModel alloc] initWithLocalVideoModel:localVideoModel danMuDic:dic];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressSliderView.delegate = self;
    [self.view setWantsLayer: YES];
    
    __weak typeof(self)weakSelf = self;
    [[[JHVLCMedia alloc] initWithURL: [self.vm videoURL]] parseWithBlock:^(VLCMedia *aMedia) {
        //设置播放视图的约束
        [weakSelf setUpPlayerViewConstraintsWithMedia: aMedia];
        
        weakSelf.player = [[VLCMediaPlayer alloc] initWithVideoView:  weakSelf.playerView];
        //初始化视频信息
        weakSelf.player.media = aMedia;
        //初始化音量
        weakSelf.player.audio.volume = self.volumeSliderView.intValue * 2;
        [weakSelf startPlay];
    }];
    
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [self.timer invalidate];
    [self.rander stop];
    [self.player stop];
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
}
- (IBAction)clickVolumeSlider:(NSSlider *)sender {
    self.player.audio.volume = sender.intValue * 2;
}

- (IBAction)clickFullScreenButton:(NSButton *)sender {
    [self enterFullScreen];
}

#pragma mark - 私有方法
//全屏
- (void)mouseDown:(NSEvent *)theEvent{
    if (theEvent.clickCount == 2) {
        [self enterFullScreen];
    }
}

- (void)enterFullScreen{
    NSWindow *windows = [NSApplication sharedApplication].keyWindow;
    windows.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    [windows toggleFullScreen: nil];
}
//开始播放
- (void)startPlay{
    [self videoAndDanMuPlay];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(launchDanmu) userInfo: nil repeats: YES];
}
//结束播放
- (void)stopPlay{
    [self.rander stop];
    [self.player stop];
    self.playButton.state = 0;
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
//发射弹幕
- (void)launchDanmu{
    //暂停状态直接返回
     if (self.player.state == VLCMediaPlayerStatePaused) return;
    //播放弹幕
    NSArray* danMus = [self.vm currentSecondDanMuArr: [self currentSecond]];
    [danMus enumerateObjectsUsingBlock:^(DanMuDataModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rander receive: [BarrageDescriptor descriptorWithModel: obj]];
    }];
    //更新当前时间
    [self.progressSliderView updateCurrentTime:[self currentSecond] / [self videoTime]];
}
//视频当前播放时间
- (CGFloat)currentSecond{
    return self.player.time.numberValue.floatValue / 1000;
}
//视频总时长
- (CGFloat)videoTime{
    return self.player.media.length.numberValue.floatValue / 1000;
}

- (void)setUpPlayerViewConstraintsWithMedia:(VLCMedia *)aMedia{
    NSArray *mediaInfo = aMedia.tracksInformation;
    CGFloat width = .0;
    CGFloat height = .0;
    //获取视频宽高
    for (NSDictionary *dic in mediaInfo) {
        if (dic[@"width"]) width = [dic[@"width"] floatValue];
        if (dic[@"height"])  height = [dic[@"height"] floatValue];
    }
    
    [self.view addSubview: self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.playerUI.mas_top);
        make.width.equalTo(self.playerView.mas_height).multipliedBy(width / height);
        make.centerX.mas_equalTo(0);
    }];
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
            make.edges.equalTo(self.playerView);
        }];
    }
    return _rander;
}

- (VLCVideoView *)playerView {
	if(_playerView == nil) {
		_playerView = [[VLCVideoView alloc] init];
	}
	return _playerView;
}

@end
