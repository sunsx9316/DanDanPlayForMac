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
#import "BarrageHeader.h"
#import "DanMuModel.h"
#import "BarrageDescriptor+Tools.h"

#import <VLCKit/VLCKit.h>

@interface PlayerViewController ()<PlayerSlideViewDelegate>
@property (weak) IBOutlet NSView *playerUI;
@property (weak) IBOutlet PlayerSlideView *progressSliderView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet VLCVideoView *playerView;


@property (strong, nonatomic) PlayViewModel *vm;
@property (nonatomic, strong) VLCMediaPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) BarrageRenderer *rander;
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
    
    
    self.player = [[VLCMediaPlayer alloc] initWithVideoView:self.playerView];
    [self.player setMedia: [[VLCMedia alloc] initWithURL:[self.vm videoURL]]];
    [self startPlay];
    
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [self.timer invalidate];
    [self.rander stop];
    [self.player stop];
}

- (IBAction)clickPlayButton:(NSButton *)sender {
    
}
- (IBAction)clickNextButton:(NSButton *)sender {
    
}
- (IBAction)clickPreButton:(NSButton *)sender {
    
}
- (IBAction)clickStopButton:(NSButton *)sender {
    
}
- (IBAction)clickVolumeSlider:(NSSlider *)sender {
    
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
//播放弹幕和视频
- (void)videoAndDanMuPlay{
    [self.rander start];
    [self.player play];
}
//发射弹幕
- (void)launchDanmu{
    //暂停状态直接返回
    // if (self.isPause) return;
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
    return self.player.time.numberValue.floatValue;
}
//视频总时长
- (CGFloat)videoTime{
    return self.player.media.length.numberValue.floatValue;
}

#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    
}
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    
    
}

#pragma mark - 懒加载
- (BarrageRenderer *)rander {
    if(_rander == nil) {
        _rander = [[BarrageRenderer alloc] init];
        [_rander setSpeed: 1];
        [self.view addSubview:_rander.view positioned:NSWindowAbove relativeTo:self.playerView];
    }
    return _rander;
}

@end
