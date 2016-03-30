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

#import "PlayerListTableView.h"
#import "PlayerHUDMessageView.h"
#import "PlayerHoldView.h"
#import "PlayLastWatchVideoTimeView.h"
#import "PlayerControlView.h"
#import "DanmakuColorMenuItem.h"
#import "DanmakuModeMenuItem.h"
#import "RespondKeyboardTextField.h"
#import "AddTrackingAreaButton.h"
#import "VolumeControlView.h"

#import "MatchModel.h"
#import "LocalVideoModel.h"
#import "StreamingVideoModel.h"
#import "PlayViewModel.h"

#import "VideoNameCell.h"
#import "HideDanMuAndCloseCell.h"
#import "SliderControlCell.h"
#import "TimeAxisCell.h"
#import "OnlyButtonCell.h"


#import "NSColor+Tools.h"
#import "JHDanmakuEngine+Tools.h"
#import "PlayerViewControllerMethodManager.h"
#import "JHDanmakuRender.h"
#import "JHMediaPlayer.h"

//短跳转时长
#define SHORT_JUMP_TIME 5
//普通跳转时长
#define MEDIUM_JUMP_TIME 10

#define MAX_BUFFER_TIME 3

@interface PlayerViewController ()<PlayerSlideViewDelegate, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSUserNotificationCenterDelegate, JHMediaPlayerDelegate>

@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSButton *playDanmakuControlButton;
@property (weak) IBOutlet NSButton *volumeButton;
@property (weak) IBOutlet PlayerControlView *playerControlView;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet PlayerHoldView *playerHoldView;

@property (weak) IBOutlet NSScrollView *danMuControlView;
@property (strong) IBOutlet NSScrollView *playListView;
@property (weak) IBOutlet PlayerListTableView *playerListTableView;
@property (weak) IBOutlet RespondKeyboardTextField *danmakuTextField;
@property (weak) IBOutlet NSPopUpButton *danmakuColorPopUpButton;
@property (weak) IBOutlet NSPopUpButton *danmakuModePopUpButton;
@property (strong) IBOutlet PlayLastWatchVideoTimeView *lastWatchVideoTimeView;
@property (strong) IBOutlet NSMenu *rightClickMenu;
//最底部的进度条
@property (weak) IBOutlet PlayerSlideView *smallSlideView;
@property (strong, nonatomic) AddTrackingAreaButton *showDanMuControllerViewButton;
@property (strong, nonatomic) PlayerHUDMessageView *messageView;
@property (strong, nonatomic) VolumeControlView *volumeControlView;

@property (strong, nonatomic) JHMediaPlayer *player;

@property (strong, nonatomic) JHDanmakuEngine *rander;

@property (strong, nonatomic) PlayViewModel *vm;
//快捷键映射
@property (strong, nonatomic) NSArray *keyMap;
@property (assign, nonatomic) NSInteger danMuOffsetTime;
@end

@implementation PlayerViewController
{
    //是否处于全屏状态
    BOOL _fullScreen;
    //判断用户是否点击了暂停
    BOOL _userPause;
    //时间格式化工具
    NSDateFormatter *_formatter;
    NSTimer *_autoHideTimer;
}
#pragma mark - 方法
- (instancetype)initWithVideos:(NSArray *)videoModels danMuDic:(NSDictionary *)dic matchName:(NSString *)matchName episodeId:(NSString *)episodeId{
    if (self = [super initWithNibName: @"PlayerViewController" bundle: nil]) {
        self.vm = [[PlayViewModel alloc] initWithVideoModels:videoModels danMuDic:dic episodeId:episodeId];
        [self postMatchMessageWithMatchName: matchName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuColor:) name:NSColorPanelColorDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanMuDic:) name:@"DANMAKU_CHOOSE_OVER" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openStreamVCChooseOver:) name:@"OPEN_STREAM_VC_CHOOSE_OVER" object: nil];
    
    self.vm.currentIndex = 0;
    //初始化播放器相关参数
    [self setupOnce];
    [self.player videoSizeWithCompletionHandle:^(CGSize size) {
        [self setupWithMediaSize:size];
        [self startPlay];
    }];
}


//全屏
- (void)mouseDown:(NSEvent *)theEvent{
    if (theEvent.clickCount == 2) {
        [self toggleFullScreen];
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent{
    if (self.player.mediaType == JHMediaTypeNetMedia) {
        [NSMenu popUpContextMenu:self.rightClickMenu withEvent:theEvent forView:self.view];
    }
}

- (void)keyDown:(NSEvent *)theEvent{
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

- (void)scrollWheel:(NSEvent *)theEvent{
    [self volumeValueAddTo:0 addBy:theEvent.scrollingDeltaY];
}

#pragma mark 播放器相关
- (IBAction)clickPlayButton:(NSButton *)sender {
    if (self.player.status == JHMediaPlayerStatusStop) {
        [self startPlay];
        _userPause = NO;
    }else if (sender.state){
        [self videoAndDanMuPlay];
        _userPause = NO;
    }else{
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

- (void)clickShowDanMuControllerButton:(NSButton *)button{
    CGRect frame;
    if (self.playerControlView.alphaValue == 0) {
        frame = CGRectMake(self.view.frame.size.width - 300, 0, 300, self.view.frame.size.height);
    }else{
        frame = CGRectMake(self.view.frame.size.width - 300, self.playerControlView.frame.size.height, 300, self.view.frame.size.height - self.playerControlView.frame.size.height);
    }
    [PlayerViewControllerMethodManager showDanMuControllerView:self.danMuControlView withRect:frame hideButton:self.showDanMuControllerViewButton];
}

- (IBAction)clickPlayListViewButton:(NSButton *)sender {
    sender.state?
    [PlayerViewControllerMethodManager hidePlayerListView:self.playListView withRect:NSMakeRect(-300, self.view.bounds.size.height / 2, 300, 50)]
    :[PlayerViewControllerMethodManager showPlayerListView:self.playListView withRect:NSMakeRect(0, self.playerControlView.frame.size.height, 300, self.view.frame.size.height - self.playerControlView.frame.size.height)];
}

- (IBAction)clickStopButton:(NSButton *)sender {
    [self saveCurrentVideoTime];
    [self stopPlay];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (void)clickVolumeSlider:(NSSlider *)sender {
    [self volumeValueAddTo:sender.floatValue addBy:0];
}

- (void)clickVolumeButton:(NSButton *)button{
    self.volumeControlView.isHidden ? [self.volumeControlView show] : [self.volumeControlView hide];
}

- (IBAction)clickFullScreenButton:(NSButton *)sender {
    [self toggleFullScreen];
}

- (IBAction)clickDanmakuControlButton:(NSButton *)sender {
    self.rander.canvas.hidden = sender.state;
    self.playDanmakuControlButton.state = sender.state;
}

- (IBAction)clickDanmakuColorButton:(NSPopUpButton *)sender {
    if (sender.indexOfSelectedItem == 7) {
        NSColorPanel *panel = [NSColorPanel sharedColorPanel];
        [panel setTarget:self];
        [panel orderFront:self];
    }
}

- (void)launchDanmaku{
    NSString *text = self.danmakuTextField.stringValue;
    if (!text.length) return;
    
    DanmakuModeMenuItem *item = (DanmakuModeMenuItem *)self.danmakuModePopUpButton.selectedItem;
    DanmakuColorMenuItem *colorItem = (DanmakuColorMenuItem *)self.danmakuColorPopUpButton.selectedItem;
    
    NSInteger mode = item.mode;
    NSInteger color = colorItem.itemColor;
    [PlayerViewControllerMethodManager launchDanmakuWithText:text color:color mode:mode time:self.rander.currentTime + self.rander.offsetTime episodeId:self.vm.episodeId completionHandler:^(DanMuDataModel *model, NSError *error) {
        //无错误发射
        if (!error) {
            ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithModel:model shadowStyle:[UserDefaultManager danMufontSpecially] fontSize:0 font:[UserDefaultManager danMuFont]];
            danmaku.appearTime = self.rander.currentTime + self.rander.offsetTime;
            NSMutableAttributedString *str = [danmaku.attributedString mutableCopy];
            [str addAttributes:@{NSUnderlineColorAttributeName:[NSColor greenColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange(0, str.length)];
            danmaku.attributedString = str;
            self.danmakuTextField.stringValue = @"";
            self.messageView.text.stringValue = @"发射成功";
            [self.messageView showHUD];
            [self.rander addDanmaku: danmaku];
        }else{
            self.messageView.text.stringValue = @"发射失败";
            [self.messageView showHUD];
        }
    }];
}


#pragma mark - 私有方法

- (void)dealloc{
    [self.player removeObserver:self forKeyPath:@"volume"];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [NSApplication sharedApplication].mainWindow.title = @"弹弹play";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_OVER" object: nil];
}

- (void)timeOffset:(NSInteger)time{
    self.rander.offsetTime = time;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.volumeControlView.volumeSlider.floatValue = [change[@"new"] floatValue];
}

#pragma mark view尺寸变化相关
- (void)danMuControlViewResize{
    if (self.danMuControlView.hidden) {
        self.danMuControlView.frame = CGRectMake(self.view.bounds.size.width - 300 * !self.danMuControlView.hidden, self.view.bounds.size.height / 2, 300, 50);
    }else{
        self.danMuControlView.frame = self.playerControlView.alphaValue ?
        CGRectMake(self.view.bounds.size.width - 300 * !self.danMuControlView.hidden, self.playerControlView.frame.size.height, 300, self.view.bounds.size.height - self.playerControlView.frame.size.height) :
        CGRectMake(self.view.bounds.size.width - 300 * !self.danMuControlView.hidden, 0, 300, self.view.bounds.size.height);
    }
}

- (void)playListViewResize{
    if (self.playListView.hidden) {
        self.playListView.frame = CGRectMake(-300 * self.playListView.hidden, self.view.bounds.size.height / 2, 300, 50);
    }else{
        self.playListView.frame = self.playerControlView.alphaValue ?
        CGRectMake(-300 * self.playListView.hidden, self.playerControlView.frame.size.height, 300, self.view.bounds.size.height - self.playerControlView.frame.size.height) :
        CGRectMake(-300 * self.playListView.hidden, 0, 300, self.view.bounds.size.height);
    }
}

- (void)danmakuCanvasResize{
    CGRect frame = self.playerHoldView.frame;
    if ([UserDefaultManager turnOnCaptionsProtectArea]) {
        CGFloat offset = frame.size.height * 0.15;
        frame.origin.y += offset;
        frame.size.height -= offset;
    }
    self.rander.canvas.frame = frame;
}
#pragma mark 加载网络视频
- (void)openStreamVCChooseOver:(NSNotification *)notification{
    [self.vm addVideosModel:notification.userInfo[@"videos"]];
    //网络视频 episode应该为空
    self.vm.episodeId = nil;
    [self changeCurrentIndex:[self.vm videoCount] - 1];
}

#pragma mark 重新加载弹幕 更新进度
- (void)reloadDanmakuWithIndex:(NSInteger)index{
    [JHProgressHUD showWithMessage:@"解析中..." style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(300, 100) fontSize: 20 dismissWhenClick: NO];
    
    [self.vm reloadDanmakuWithIndex:index completionHandler:^(CGFloat progress, NSString *videoMatchName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [JHProgressHUD disMiss];
                id vm = [self.vm videoModelWithIndex:index];
                if ([vm isKindOfClass:[LocalVideoModel class]]) {
                    [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: (LocalVideoModel *)vm]];
                }
            }else{
                [JHProgressHUD updateProgress:progress];
                if (progress == 0.5) {
                    [JHProgressHUD updateMessage:@"分析视频..."];
                }else if (progress == 1){
                    [JHProgressHUD updateMessage:@"下载弹幕..."];
                    [self postMatchMessageWithMatchName: videoMatchName];
                    [JHProgressHUD disMiss];
                }
            }
        });
    }];
}

#pragma mark 改变发送弹幕颜色
- (void)changeDanmakuColor:(NSNotification *)sender{
    NSColorPanel *panel = sender.object;
    DanmakuColorMenuItem *item = (DanmakuColorMenuItem *)[self.danmakuColorPopUpButton itemAtIndex:7];
    [item setItemColor:panel.color];
}

#pragma mark 窗口相关
//进入全屏方法
- (void)toggleFullScreen{
    NSWindow *windows = [NSApplication sharedApplication].keyWindow;
    windows.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    [windows toggleFullScreen: nil];
}

//窗口大小变化
- (void)windowDidResize:(NSNotification *)notification{
    [self danMuControlViewResize];
    [self playListViewResize];
    [self danmakuCanvasResize];
}

//进入全屏通知
- (void)windowWillEnterFullScreen:(NSNotification *)notification{
    _fullScreen = YES;
}

//退出全屏通知
- (void)windowWillExitFullScreen:(NSNotification *)notification{
    _fullScreen = NO;
    [_autoHideTimer invalidate];
}


#pragma mark 更换弹幕字典通知
- (void)changeDanMuDic:(NSNotification *)notification{
    [self stopPlay];
    [self.player setMediaURL:[self.vm currentVideoURL]];
    self.vm.danmakusDic = notification.userInfo;
    [self.rander addAllDanmakusDic:notification.userInfo];
    [self.playerListTableView reloadData];
    [self.player videoSizeWithCompletionHandle:^(CGSize size) {
        [self setupWithMediaSize:size];
        [self startPlay];
    }];
}

#pragma mark 截图
- (void)snapShot{
    NSDateFormatter *forematter = [NSDateFormatter new];
    [forematter setDateFormat:@"YYYY_MM_dd HH_mm_ss"];
    [self.player saveVideoSnapshotAt:[[UserDefaultManager screenShotPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %@", [self.vm currentVideoName], [forematter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]]] withWidth:0 andHeight:0 format:[UserDefaultManager defaultScreenShotType]];
}

#pragma mark 推送
- (void)postMatchMessageWithMatchName:(NSString *)matchName{
    //删除已经显示过的通知(已经存在用户的通知列表中的)
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    
    //删除已经在执行的通知(比如那些循环递交的通知)
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]){
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"弹弹play";
    notification.informativeText = matchName?[NSString stringWithFormat:@"视频自动匹配为 %@", matchName]:@"并没有匹配到视频";
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

#pragma mark 播放相关
//开始播放
- (void)startPlay{
    [self videoAndDanMuPlay];
    if (self.player.mediaType == JHMediaTypeNetMedia) {
        [self videoAndDanMuPause];
    }
}
//结束播放
- (void)stopPlay{
    [self.rander stop];
    [self.player stop];

    [self.smallSlideView updateCurrentProgress:0];
    [self.smallSlideView updateBufferProgress:0];
    [self.playerControlView.slideView updateBufferProgress:0];
    [self.playerControlView.slideView updateCurrentProgress:0];
    self.timeLabel.stringValue = @"00:00 / 00:00";
}

//更改当前视频
- (void)changeCurrentIndex:(NSInteger)index{
    [self saveCurrentVideoTime];
    [self stopPlay];
    self.vm.currentIndex = index;
}
//保存当前视频时间
- (void)saveCurrentVideoTime{
    [UserDefaultManager setVideoPlayHistoryWithHash:[self.vm currentVideoHash] time:[self.player currentTime]];
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


/**
 *  改音量
 *
 *  @param addTo 增加到
 *  @param addBy 增加
 */
- (void)volumeValueAddTo:(CGFloat)addTo addBy:(CGFloat)addBy{
    if (addTo == 0 && addBy == 0) {
        self.player.volume = 0;
    }else if (addTo) {
        self.player.volume = addTo;
    }else if (addBy){
        [self.player volumeJump:addBy];
    }
    self.messageView.text.stringValue = [NSString stringWithFormat:@"音量: %ld", (long)self.player.volume];
    [self.messageView showHUD];
}

- (void)loadLocaleDanMu{
    [PlayerViewControllerMethodManager loadLocaleDanMuWithBlock:^(NSDictionary *dic) {
        if (dic.count > 0) {
            self.vm.danmakusDic = dic;
            [self.rander addAllDanmakusDic:dic];
            [self.player setPosition:0];
        }else{
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = kNoFoundDanmaku;
            [alert runModal];
        }
    }];
}



#pragma mark 快捷键调用的方法
- (void)targetMethodWithID:(NSNumber *)ID{
    switch (ID.integerValue) {
        case 0:
            [self toggleFullScreen];
            break;
        case 1:
            self.playButton.state = !self.playButton.state;
            [self clickPlayButton:self.playButton];
            break;
        case 2:
            [self volumeValueAddTo:0 addBy: -20];
            break;
        case 3:
            [self volumeValueAddTo:0 addBy: 20];
            break;
        case 4:
            [self volumeValueAddTo:0 addBy: 0];
            break;
        case 5:
            self.rander.currentTime += SHORT_JUMP_TIME;
            [self.player jump: SHORT_JUMP_TIME];
            break;
        case 6:
            self.rander.currentTime -= SHORT_JUMP_TIME;
            [self.player jump: -SHORT_JUMP_TIME];
            break;
        case 7:
            self.rander.currentTime += MEDIUM_JUMP_TIME;
            [self.player jump: MEDIUM_JUMP_TIME];
            break;
        case 8:
            self.rander.currentTime -= MEDIUM_JUMP_TIME;
            [self.player jump: -MEDIUM_JUMP_TIME];
            break;
        case 9:
            [self snapShot];
            break;
        default:
            break;
    }
}

#pragma mark 初始化相关
//只需要初始化一次的属性
- (void)setupOnce{
    __weak typeof(self)weakSelf = self;
    
    //必须设置 不然弹幕无法显示
    [self.view setWantsLayer: YES];
    [self.playerControlView setMouseEnteredCallBackBlock:^{
        weakSelf.playerControlView.animator.alphaValue = 1;
        [weakSelf danMuControlViewResize];
        [weakSelf playListViewResize];
    }];

    [self.playerControlView setMouseExitedCallBackBlock:^{
        weakSelf.playerControlView.animator.alphaValue = 0;
        [weakSelf danMuControlViewResize];
        [weakSelf playListViewResize];
    }];

    //设置播放页面回调
    [self.playerHoldView setFilePickBlock:^(NSArray *filePaths) {
        if (filePaths.count > 0) {
            NSInteger oldCount = [weakSelf.vm videoCount];
            [weakSelf.vm addVideosModel:filePaths];
            [weakSelf changeCurrentIndex:oldCount - 1];
            [weakSelf clickNextButton:nil];
        }
    }];
    //设置发送弹幕输入框回调
    [self.danmakuTextField setRespondBlock:^{
        [weakSelf launchDanmaku];
    }];
    
    //左右两边的页面初始化
    [self.view addSubview: self.danMuControlView positioned:NSWindowAbove relativeTo:self.rander.canvas];
    [self.view addSubview: self.playListView positioned:NSWindowAbove relativeTo:self.rander.canvas];
    
    //播放控制面板
    self.playerControlView.slideView.delegate = self;
    self.smallSlideView.delegate = self;
    //弹幕控制面板
    self.showDanMuControllerViewButton.alphaValue = 0;
    NSArray *colorArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmakuColor" ofType:@"plist"]];
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
    
    //其它
    //上次观看时间视图
    [self.view addSubview:self.lastWatchVideoTimeView positioned:NSWindowAbove relativeTo:self.rander.canvas];
    [self.lastWatchVideoTimeView setContinusBlock:^(NSTimeInterval time) {
        [weakSelf.player setPosition:time / weakSelf.player.length];
        weakSelf.rander.currentTime = time;
    }];
    [self.lastWatchVideoTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(57);
        make.left.centerY.mas_equalTo(0);
    }];
    
    [self danMuControlViewResize];
    [self playListViewResize];
    [self danmakuCanvasResize];
}

- (void)setupWithMediaSize:(CGSize)aMediaSize{
    CGSize screenSize = [NSScreen mainScreen].frame.size;
//    //宽高有一个为0 使用布满全屏的约束
    if (!aMediaSize.width || !aMediaSize.height) {
        [self.player.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //当把视频放大到屏幕大小时 如果视频高超过屏幕高 则使用这个约束
    }else if (screenSize.width * (aMediaSize.height / aMediaSize.width) > screenSize.height) {
        [self.player.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.bottom.mas_equalTo(0);
            make.width.equalTo(self.player.mediaView.mas_height).multipliedBy(aMediaSize.width / aMediaSize.height);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
        }];
        //没超过 使用这个约束
    }else{
        [self.player.mediaView  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.height.equalTo(self.player.mediaView.mas_width).multipliedBy(aMediaSize.height / aMediaSize.width);
        }];
    }
    self.player.mediaView.layer.position = CGPointZero;
    self.player.mediaView.layer.bounds = self.playerHoldView.bounds;
    
    //设置其它参数
    [NSApplication sharedApplication].keyWindow.title = [self.vm currentVideoName];
    [NSApplication sharedApplication].mainWindow.title = [self.vm currentVideoName];
    _danMuOffsetTime = 0;
    _userPause = NO;
    self.playerControlView.alphaValue = 0;
    //只有官方弹幕库启用发送弹幕功能
    self.danmakuTextField.enabled = self.vm.episodeId != nil;
    [self resetMenuByOpenStreamDic];
    
    NSInteger time = [self.vm currentVideoLastVideoTime];
    if (time > 0) {
        self.lastWatchVideoTimeView.videoTimeTextField.stringValue = [NSString stringWithFormat:@"上次播放时间: %.2ld:%.2ld",time / 60, time % 60];
        self.lastWatchVideoTimeView.time = time;
        [self.lastWatchVideoTimeView show];
    }
}

#pragma mark - NSUserNotificationDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    //强制显示
    return YES;
}


#pragma mark - JHMediaPlayerDelegate
- (void)mediaPlayer:(JHMediaPlayer *)player progress:(float)progress formatTime:(NSString *)formatTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新当前时间
        self.timeLabel.stringValue = formatTime;
        [self.playerControlView.slideView updateCurrentProgress:progress];
        [self.smallSlideView updateCurrentProgress:progress];
    });
}

- (void)mediaPlayer:(JHMediaPlayer *)player bufferTimeProgress:(float)progress onceBufferTime:(float)onceBufferTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerControlView.slideView updateBufferProgress:progress];
        [self.smallSlideView updateBufferProgress:progress];
    });
    if (onceBufferTime > MAX_BUFFER_TIME && self.player.status == JHMediaPlayerStatusPause && !_userPause) {
        [self videoAndDanMuPlay];
    }
}



- (void)mediaPlayer:(JHMediaPlayer *)player statusChange:(JHMediaPlayerStatus)status{
    switch (status) {
        case JHMediaPlayerStatusPause:
            [self.rander pause];
            self.playButton.state = NSCancelButton;
            break;
        case JHMediaPlayerStatusStop:
            self.playButton.state = NSCancelButton;
            break;
        case JHMediaPlayerStatusPlaying:
            [self.rander start];
            self.playButton.state = NSOKButton;
            break;
        default:
            break;
    }
}

#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.player setPosition: endValue];
    self.rander.currentTime = self.player.length * endValue;
}
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.player setPosition: endValue];
    self.rander.currentTime = self.player.length * endValue;
}

#pragma mark - NSTableView

- (IBAction)doubleClickPlayerList:(PlayerListTableView *)sender {
    [self changeCurrentIndex:[sender selectedRow]];
    [self reloadDanmakuWithIndex:self.vm.currentIndex];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([tableView isKindOfClass:[PlayerListTableView class]]) {
        return [self.vm videoCount];
    }
    return 7;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    __weak typeof(self)weakSelf = self;
    if ([tableView isKindOfClass:[PlayerListTableView class]]) {
        VideoNameCell *cell = [tableView makeViewWithIdentifier:@"VideoNameCell" owner:self];
        [cell setTitle:[self.vm videoNameWithIndex:row] iconHide:[self.vm showPlayIconWithIndex:row] callBack:^{
            //删除的行是当前播放视频 播放下一个视频
            if (row == weakSelf.vm.currentIndex) {
                if (weakSelf.vm.videoCount == 1) {
                    [weakSelf clickStopButton:nil];
                }else{
                    [weakSelf clickNextButton:nil];
                }
            }
            [weakSelf.vm removeVideoAtIndex:row];
            [weakSelf.playerListTableView reloadData];
        }];
        return cell;
    }
    
    if (row == 0) {
        HideDanMuAndCloseCell *cell = [tableView makeViewWithIdentifier:@"HideDanMuAndCloseCell" owner: self];
        [cell setCloseBlock:^{
            [PlayerViewControllerMethodManager hideDanMuControllerView:weakSelf.danMuControlView withRect:CGRectMake(weakSelf.view.frame.size.width, weakSelf.view.bounds.size.height / 2, 300, 50) showButton:weakSelf.showDanMuControllerViewButton];
        }];
        [cell setSelectBlock:^(NSInteger num, NSInteger status) {
            status?[weakSelf.rander.globalFilterDanmaku addObject:@(num)]:[weakSelf.rander.globalFilterDanmaku removeObject:@(num)];
        }];
        return cell;
    }else if (row == 1){
        SliderControlCell *cell = [tableView makeViewWithIdentifier:@"SliderControlCell" owner:self];
        [cell setWithBlock:^(CGFloat value) {
            weakSelf.rander.globalFont = [[NSFontManager sharedFontManager] convertFont:[UserDefaultManager danMuFont] toSize:value];
        } sliderControlStyle: sliderControlStyleFontSize];
        return cell;
    }else if (row == 2){
        SliderControlCell *cell = [tableView makeViewWithIdentifier:@"SliderControlCell" owner:self];
        [cell setWithBlock:^(CGFloat value) {
            [weakSelf.rander setSpeed: value];
        } sliderControlStyle: sliderControlStyleSpeed];
        return cell;
    }else if (row == 3){
        SliderControlCell *cell = [tableView makeViewWithIdentifier:@"SliderControlCell" owner:self];
        [cell setWithBlock:^(CGFloat value) {
            weakSelf.rander.canvas.alphaValue = value;
        } sliderControlStyle: sliderControlStyleOpacity];
        return cell;
    }else if (row == 4){
        TimeAxisCell * cell = [tableView makeViewWithIdentifier:@"TimeAxisCell" owner: self];
        [cell setTimeOffsetBlock:^(NSInteger num) {
            if (num == 0) weakSelf.danMuOffsetTime = 0;
            else weakSelf.danMuOffsetTime += num;
            if (!(weakSelf.rander.offsetTime == 0 && num == 0)) [weakSelf timeOffset: weakSelf.danMuOffsetTime];
            
            weakSelf.messageView.text.stringValue = [NSString stringWithFormat:@"%@%ld秒", weakSelf.danMuOffsetTime >= 0 ? @"+" : @"", (long)weakSelf.danMuOffsetTime];
            [weakSelf.messageView showHUD];
        }];
        
        return cell;
    }else if (row == 5){
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"重新选择弹幕";
        [cell setButtonDownBlock:^{
            SearchViewController *vc = [[SearchViewController alloc] init];
            vc.searchText = [weakSelf.vm currentVideoName];
            [weakSelf presentViewControllerAsSheet: vc];
        }];
        return cell;
    }else if (row == 6){
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"加载本地弹幕";
        [cell setButtonDownBlock:^{
            [weakSelf loadLocaleDanMu];
        }];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    if ([tableView isKindOfClass:[PlayerListTableView class]]) {
        return 30;
    }
    
    if (row == 0 || row == 4) {
        return 120;
    }
    return 60;
}

#pragma mark - NSMenu
- (void)resetMenuByOpenStreamDic{
    //只有网络视频才显示
    if (self.player.mediaType == JHMediaTypeLocaleMedia) return;
    
    NSArray *arr = [self.rightClickMenu itemArray];
    NSInteger highCount = [self.vm openStreamCountWithQuality:streamingVideoQualityHigh];
    NSInteger lowCount = [self.vm openStreamCountWithQuality:streamingVideoQualityLow];
    for (NSInteger i = 0 ;i < arr.count; ++i) {
        NSMenuItem *item = arr[i];
        [item.submenu removeAllItems];
        //高画质
        if (i == 0) {
            for (NSInteger i = 0; i < highCount; ++i) {
                NSMenuItem *sitem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"备胎线路%ld", i + 1] action:@selector(clickItem:) keyEquivalent:@""];
                sitem.tag = 20 + i;
                [item.submenu addItem:sitem];
            }
        //渣画质
        }else{
            for (NSInteger i = 0; i < lowCount; ++i) {
                NSMenuItem *sitem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"备胎线路%ld", i + 1] action:@selector(clickItem:) keyEquivalent:@""];
                sitem.tag = 10 + i;
                [item.submenu addItem:sitem];
            }
        }
    }
    
}

- (void)clickItem:(NSMenuItem *)item{
    streamingVideoQuality quality;
    NSInteger index;
    if (item.tag >= 20) {
        quality = streamingVideoQualityHigh;
        index = item.tag - 20;
    }else{
        quality = streamingVideoQualityLow;
        index = item.tag - 10;
    }
    [self.vm setOpenStreamURLWithQuality: quality index:index];
    [self changeCurrentIndex:self.vm.currentIndex - 1];
    [self clickNextButton:nil];
}

#pragma mark - 懒加载

- (NSDateFormatter *)formatter{
    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"mm:ss"];
    }
    return _formatter;
}


- (AddTrackingAreaButton *)showDanMuControllerViewButton {
    if(_showDanMuControllerViewButton == nil) {
        _showDanMuControllerViewButton = [[AddTrackingAreaButton alloc] init];
        _showDanMuControllerViewButton.bordered = NO;
        _showDanMuControllerViewButton.bezelStyle = NSTexturedRoundedBezelStyle;
        __weak typeof(_showDanMuControllerViewButton)weakButton = _showDanMuControllerViewButton;
        [_showDanMuControllerViewButton setMouseExitedCallBackBlock:^{
            weakButton.animator.alphaValue = 0;
        }];
        [_showDanMuControllerViewButton setMouseEnteredCallBackBlock:^{
            weakButton.animator.alphaValue = 1;
        }];
        [_showDanMuControllerViewButton setImage: [NSImage imageNamed:@"show_damaku_controller"]];
        [_showDanMuControllerViewButton setTarget: self];
        [_showDanMuControllerViewButton setAction: @selector(clickShowDanMuControllerButton:)];
        [self.view addSubview: _showDanMuControllerViewButton positioned:NSWindowAbove relativeTo: self.playerControlView];
        [_showDanMuControllerViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(100);
            make.right.centerY.mas_equalTo(0);
        }];
    }
    return _showDanMuControllerViewButton;
}

- (PlayerHUDMessageView *)messageView {
    if(_messageView == nil) {
        _messageView = [[PlayerHUDMessageView alloc] init];
        [self.view addSubview: _messageView positioned:NSWindowAbove relativeTo: self.rander.canvas];
        [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(100);
            make.center.mas_equalTo(0);
        }];
    }
    return _messageView;
}

- (NSArray *)keyMap {
    if(_keyMap == nil) {
        _keyMap = [UserDefaultManager customKeyMap];
    }
    return _keyMap;
}

- (JHDanmakuEngine *)rander {
    if(_rander == nil) {
        _rander = [[JHDanmakuEngine alloc] init];
        _rander.turnonBackFunction = YES;
        [_rander addAllDanmakusDic:self.vm.danmakusDic];
        [_rander setSpeed: [UserDefaultManager danMuSpeed]];
        _rander.canvas.alphaValue = [UserDefaultManager danMuOpacity];
        
        [self.view addSubview:_rander.canvas positioned:NSWindowAbove relativeTo:self.playerHoldView];
    }
    return _rander;
}

- (VolumeControlView *)volumeControlView {
	if(_volumeControlView == nil) {
		_volumeControlView = [[VolumeControlView alloc] init];
        [_volumeControlView.volumeSlider setTarget:self];
        [_volumeControlView.volumeSlider setAction:@selector(clickVolumeSlider:)];
	}
	return _volumeControlView;
}

@end
