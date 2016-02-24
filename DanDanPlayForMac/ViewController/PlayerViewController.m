//
//  PlayerViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "MainViewController.h"
#import "MatchViewController.h"
#import "SearchViewController.h"

#import "PlayerHUDControl.h"
#import "PlayerSlideView.h"
#import "PlayerListTableView.h"
#import "PlayerHUDMessageView.h"
#import "ColorButton.h"
#import "PlayViewModel.h"
#import "DanMuModel.h"
#import "PlayerHoldView.h"

#import "HideDanMuAndCloseCell.h"
#import "SliderControlCell.h"
#import "TimeAxisCell.h"
#import "OnlyButtonCell.h"

#import "VLCMedia+Tools.h"
#import "PlayerViewControllerMethodManager.h"

#import "JHDanmakuRender.h"
#import "JHDanmakuEngine+Tools.h"

#import <VLCKit/VLCKit.h>


@interface PlayerViewController ()<PlayerSlideViewDelegate, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSUserNotificationCenterDelegate, VLCMediaPlayerDelegate>

//非全屏状态面板
@property (weak) IBOutlet NSView *playerControl;
@property (weak) IBOutlet PlayerSlideView *progressSliderView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSSlider *volumeSliderView;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSLayoutConstraint *playerUIHeight;
@property (weak) IBOutlet PlayerHoldView *playerHoldView;

//hud面板
@property (strong) IBOutlet PlayerHUDControl *playerHUDControl;
@property (weak) IBOutlet NSTextField *playerHUDCurrentTimeLabel;
@property (weak) IBOutlet NSTextField *playerHUDVideoTimeLabel;
@property (weak) IBOutlet NSSlider *playerHUDProgressSliderView;
@property (weak) IBOutlet NSTextField *videoTitleLabel;
@property (weak) IBOutlet NSSlider *playerVolumeSlider;
@property (weak) IBOutlet NSButton *playHUDButton;


//全屏模式和非全屏模式都存在
@property (weak) IBOutlet NSScrollView *danMuControlView;
@property (strong) IBOutlet NSScrollView *playListView;
@property (weak) IBOutlet PlayerListTableView *playerListTableView;

@property (strong, nonatomic) NSButton *showDanMuControllerViewButton;
@property (strong, nonatomic) PlayerHUDMessageView *messageView;

@property (strong, nonatomic) VLCVideoView *playerView;
@property (nonatomic, strong) VLCMediaPlayer *player;

@property (strong, nonatomic) JHDanmakuEngine *rander;

@property (strong, nonatomic) PlayViewModel *vm;
//跟踪区域
@property (strong, nonatomic) NSTrackingArea *trackingArea;
//快捷键映射
@property (strong, nonatomic) NSArray *keyMap;
@property (strong, nonatomic) NSTimer *HUDControlTimer;
@end

@implementation PlayerViewController
{
    //弹幕偏移时间
    NSInteger _danMuOffsetTime;
    //是否处于全屏状态
    BOOL _fullScreen;
    //时间格式化工具
    NSDateFormatter *_formatter;
    
}
#pragma mark - 方法
- (instancetype)initWithLocaleVideos:(NSArray *)localVideoModels danMuArr:(NSArray *)arr matchName:(NSString *)matchName{
    if (self = [super initWithNibName: @"PlayerViewController" bundle: nil]) {
        self.vm = [[PlayViewModel alloc] initWithLocalVideoModels:localVideoModels danMuArr:arr];
        [self postMatchMessageWithMatchName: matchName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanMuDic:) name:@"danMuChooseOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMathchVideoName:) name:@"mathchVideo" object: nil];
    
    self.vm.currentIndex = 0;
    [self.vm currentVLCMediaWithCompletionHandler:^(VLCMedia *responseObj) {
        //初始化播放器相关参数
        [self setupOnce];
        [self setupWithMedia: responseObj];
        [self startPlay];
    }];
}


//全屏
- (void)mouseDown:(NSEvent *)theEvent{
    if (theEvent.clickCount == 2) {
        [self toggleFullScreen];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent{
    NSPoint point = theEvent.locationInWindow;
    if (_fullScreen) {
        [PlayerViewControllerMethodManager showCursorAndHUDPanel:self.playerHUDControl];
        [self.HUDControlTimer invalidate];
        self.HUDControlTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideCursorAndHUDPanel:) userInfo:nil repeats:NO];
    }
    
    if (point.x > self.view.frame.size.width - 50) {
        [self showDanMuControllerButton];
    }else{
        [self hideDanMuControllerButton];
    }
}

- (void)hideCursorAndHUDPanel:(NSTimer *)timer{
    [PlayerViewControllerMethodManager hideCursorAndHUDPanel:self.playerHUDControl];
    [timer invalidate];
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

- (IBAction)clickFFButton:(NSButton *)sender {
    [self.player shortJumpForward];
}
- (IBAction)clickREWButton:(NSButton *)sender {
    [self.player shortJumpBackward];
}


- (void)clickShowDanMuControllerButton:(NSButton *)button{
    [PlayerViewControllerMethodManager showDanMuControllerView:self.danMuControlView withRect:NSMakeRect(self.view.frame.size.width - 300, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height) hideButton:self.showDanMuControllerViewButton];
}

- (IBAction)clickStopButton:(NSButton *)sender {
    [self stopPlay];
    [NSApplication sharedApplication].mainWindow.title = @"弹弹play";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playOver" object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self.view removeTrackingArea:self.trackingArea];
    self.vm = nil;
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

- (IBAction)clickPlayListViewButton:(NSButton *)sender {
    sender.state
    ?[PlayerViewControllerMethodManager hidePlayerListView:self.playListView withRect:NSMakeRect(-300, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height)]
    :[PlayerViewControllerMethodManager showPlayerListView:self.playListView withRect:NSMakeRect(0, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height)];
}



#pragma mark - NSUserNotificationDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    //强制显示
    return YES;
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
    _fullScreen = YES;
    self.playerHUDControl.hidden = NO;
}

//退出全屏通知
- (void)windowWillExitFullScreen:(NSNotification *)notification{
    self.playerUIHeight.constant = 40;
    _fullScreen = NO;
    self.playerHUDControl.hidden = YES;
    [self.HUDControlTimer invalidate];
    [NSCursor unhide];
}

- (void)windowDidResize:(NSNotification *)notification{
    self.danMuControlView.frame = CGRectMake(self.view.frame.size.width - 300 * !self.danMuControlView.hidden, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height);
    self.playListView.frame = NSMakeRect(-300 * self.playListView.hidden, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height);
    CGRect frame = self.playerHoldView.frame;
    if ([UserDefaultManager turnOnCaptionsProtectArea]) {
        CGFloat offset = frame.size.height * 0.15;
        frame.origin.y = offset;
        frame.size.height -= offset;
    }
    self.rander.canvas.frame = frame;
}

- (void)changeDanMuDic:(NSNotification *)notification{
    [self.vm currentVLCMediaWithCompletionHandler:^(VLCMedia *responseObj) {
        [self stopPlay];
        [self setupWithMedia: responseObj];
        self.vm.arr = notification.userInfo[@"danmuArr"];
        [self startPlay];
        [self.playerListTableView reloadData];
    }];
}

- (void)changeMathchVideoName:(NSNotification *)notification{
    [self postMatchMessageWithMatchName: notification.userInfo[@"animateTitle"]];
}

- (void)snapShot{
    NSDateFormatter *forematter = [NSDateFormatter new];
    [forematter setDateFormat:@"YY_MM_dd hh_mm_ss"];
    [PlayerViewControllerMethodManager snapShotWithPlayer:self.player snapshotName:[NSString stringWithFormat:@"%@ %@", [self.vm currentVideoName], [forematter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]]];
}



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


//开始播放
- (void)startPlay{
    [self videoAndDanMuPlay];
}
//结束播放
- (void)stopPlay{
    [self.rander stop];
    [self.player stop];
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

- (void)showDanMuControllerButton{
    self.showDanMuControllerViewButton.animator.alphaValue = 1;
}

- (void)hideDanMuControllerButton{
    self.showDanMuControllerViewButton.animator.alphaValue = 0;
}


/**
 *  改音量
 *
 *  @param addTo 增加到
 *  @param addBy 增加
 */
- (void)volumeValueAddTo:(CGFloat)addTo addBy:(CGFloat)addBy{
    if (addTo == 0 && addBy == 0) {
        self.player.audio.volume = 0;
        self.volumeSliderView.intValue = 0;
        self.playerVolumeSlider.intValue = 0;
    }else if (addTo) {
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
    self.messageView.text.stringValue = [NSString stringWithFormat:@"音量: %d", self.player.audio.volume / 2];
    [self.messageView showHUD];
}

- (void)loadLocaleDanMu{
    [PlayerViewControllerMethodManager loadLocaleDanMuWithBlock:^(NSArray *arr) {
        if (arr.count > 0) {
            self.vm.arr = arr;
            [self.rander addAllDanmakus:self.vm.arr];
            [self.player setPosition:0];
        }else{
            [[NSAlert alertWithMessageText:@"并没有找到弹幕´_ゝ`" defaultButton:@"ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        }
    }];
}

//快捷键调用的方法
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
            [self.player shortJumpForward];
            break;
        case 6:
            [self.player shortJumpBackward];
            break;
        case 7:
            [self.player mediumJumpForward];
            break;
        case 8:
            [self.player mediumJumpBackward];
            break;
        case 9:
            [self snapShot];
            break;
        default:
            break;
    }
}

//只需要初始化一次的属性
- (void)setupOnce{
    __weak typeof(self)weakSelf = self;
    
    //必须设置 不然弹幕无法显示
    [self.view setWantsLayer: YES];
    [self.playerHoldView setupBlock:^(NSArray *filePaths) {
        if (filePaths.count > 0) {
            NSInteger oldCount = [weakSelf.vm localeVideoCount];
            [weakSelf.vm addLocalVideosModel:filePaths];
            weakSelf.vm.currentIndex = oldCount;
            [weakSelf clickNextButton:nil];
        }
    }];
    
    [self.playerHoldView addSubview:self.playerView];
    [self.view addSubview: self.playerHUDControl positioned:NSWindowAbove relativeTo:self.rander.canvas];
    [self.view addSubview: self.danMuControlView positioned:NSWindowAbove relativeTo:self.rander.canvas];
    [self.view addSubview: self.playListView positioned:NSWindowAbove relativeTo:self.rander.canvas];
    
    CGSize screenSize = [NSScreen mainScreen].frame.size;
    CGFloat playerHUDControlWidth = screenSize.width * 0.4;
    CGFloat playerHUDControlHeight = playerHUDControlWidth / 5;
    self.playerHUDControl.frame = CGRectMake((screenSize.width - playerHUDControlWidth) / 2, -playerHUDControlHeight, playerHUDControlWidth, playerHUDControlHeight);
    
    self.danMuControlView.frame = NSMakeRect(self.view.frame.size.width, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height);
    self.playListView.frame = NSMakeRect(-300, self.playerControl.frame.size.height, 300, self.view.frame.size.height - self.playerControl.frame.size.height);
    
    self.playerControl.layer.backgroundColor = [NSColor windowFrameColor].CGColor;
    self.progressSliderView.delegate = self;
    [self.view addTrackingArea:self.trackingArea];
    
    //初始化视频信息
    self.player = [[VLCMediaPlayer alloc] initWithVideoView:self.playerView];
    self.player.delegate = self;
}

- (void)setupWithMedia:(VLCMedia *)aMedia{
    CGSize videoSize = [aMedia videoSize];
    CGSize screenSize = [NSScreen mainScreen].frame.size;
    
    //宽高有一个为0 使用布满全屏的约束
    if (!videoSize.width || !videoSize.height) {
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //当把视频放大到屏幕大小时 如果视频高超过屏幕高 则使用这个约束
    }else if (screenSize.width * (videoSize.height / videoSize.width) > screenSize.height) {
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
    
    self.player.media = aMedia;
    self.playerHUDControl.hidden = !_fullScreen;
    self.videoTitleLabel.stringValue = [self.vm currentVideoName];
    
    //设置其它参数
    [NSApplication sharedApplication].mainWindow.title = [self.vm currentVideoName];
    
    //初始化音量
    self.player.audio.volume = self.volumeSliderView.intValue * 2;
    self.playerVolumeSlider.intValue = self.volumeSliderView.intValue;
    self.player.libraryInstance.debugLogging = NO;
}

#pragma mark - VLCMediaPlayerDelegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
    CGFloat currentTime = [PlayerViewControllerMethodManager currentTimeWithPlayer:self.player];
    CGFloat videoTime = [PlayerViewControllerMethodManager videoTimeWithPlayer:self.player];
    
    //更新当前时间
    if (!_fullScreen) {
        self.timeLabel.stringValue = [NSString stringWithFormat:@"%@ / %@", [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:currentTime]], [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]]];
        [self.progressSliderView updateCurrentTime:currentTime / videoTime];
    }else if(self.playerHUDControl.alphaValue){
        self.playerHUDVideoTimeLabel.stringValue = [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]];
        self.playerHUDCurrentTimeLabel.stringValue = [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:currentTime]];
        self.playerHUDProgressSliderView.floatValue = currentTime / videoTime * 100;
    }
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    if (self.player.state == VLCMediaPlayerStatePaused && [PlayerViewControllerMethodManager videoTimeWithPlayer:self.player] - [PlayerViewControllerMethodManager currentTimeWithPlayer:self.player] < 1) {
        [self clickNextButton: nil];
    }
}

#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.player setPosition: endValue];
}
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView{
    [self.player setPosition: endValue];
}

#pragma mark - NSTableView

- (IBAction)doubleClickPlayerList:(PlayerListTableView *)sender {
    self.vm.currentIndex = [sender selectedRow];
    [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: [self.vm currentLocalVideoModel]]];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([tableView isKindOfClass:[PlayerListTableView class]]) {
        return [self.vm localeVideoCount];
    }
    return 7;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableView isKindOfClass:[PlayerListTableView class]]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:@"videoNameCell" owner:self];
        cell.textField.stringValue = [self.vm localeVideoNameWithIndex:row];
        cell.imageView.hidden = [self.vm showPlayIconWithIndex:row];
        return cell;
    }
    
    __weak typeof(self)weakSelf = self;
    if (row == 0) {
        HideDanMuAndCloseCell *cell = [tableView makeViewWithIdentifier:@"HideDanMuAndCloseCell" owner: self];
        [cell setWithCloseBlock:^{
            [PlayerViewControllerMethodManager hideDanMuControllerView:weakSelf.danMuControlView withRect:NSMakeRect(weakSelf.view.frame.size.width, weakSelf.playerControl.frame.size.height, 300, weakSelf.view.frame.size.height - weakSelf.playerControl.frame.size.height) showButton:weakSelf.showDanMuControllerViewButton];
        } selectBlock:^(NSInteger num, NSInteger status) {
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
        [cell setWithBlock:^(NSInteger num) {
            _danMuOffsetTime += num;
            weakSelf.rander.currentTime += num;
            weakSelf.messageView.text.stringValue = [NSString stringWithFormat:@"%@%ld秒", _danMuOffsetTime >= 0 ? @"+" : @"", (long)_danMuOffsetTime];
            [weakSelf.messageView showHUD];
        }];
        return cell;
    }else if (row == 5){
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"重新选择弹幕";
        [cell setWithBlock:^{
            SearchViewController *vc = [[SearchViewController alloc] init];
            vc.searchText = [weakSelf.vm currentVideoName];
            [weakSelf presentViewControllerAsSheet: vc];
        }];
        return cell;
    }else if (row == 6){
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"加载本地弹幕";
        [cell setWithBlock:^{
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

#pragma mark - 懒加载

- (VLCVideoView *)playerView {
    if(_playerView == nil) {
        _playerView = [[VLCVideoView alloc] initWithFrame: self.playerHoldView.frame];
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


- (NSButton *)showDanMuControllerViewButton {
    if(_showDanMuControllerViewButton == nil) {
        _showDanMuControllerViewButton = [[NSButton alloc] init];
        _showDanMuControllerViewButton.bordered = NO;
        _showDanMuControllerViewButton.bezelStyle = NSTexturedRoundedBezelStyle;
        [_showDanMuControllerViewButton setImage: [NSImage imageNamed:@"showDanMuController"]];
        [_showDanMuControllerViewButton setTarget: self];
        [_showDanMuControllerViewButton setAction: @selector(clickShowDanMuControllerButton:)];
        [self.view addSubview: _showDanMuControllerViewButton positioned:NSWindowAbove relativeTo: self.rander.canvas];
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
        [_rander addAllDanmakus:self.vm.arr];
        [_rander setSpeed: [UserDefaultManager danMuSpeed] * 0.029 + 0.1];
        _rander.canvas.alphaValue = [UserDefaultManager danMuOpacity] / 100;
        CGRect frame = self.playerHoldView.frame;
        if ([UserDefaultManager turnOnCaptionsProtectArea]) {
            CGFloat offset = frame.size.height * 0.15;
            frame.origin.y = offset;
            frame.size.height -= offset;
        }
        _rander.canvas.frame = frame;
        [self.view addSubview:_rander.canvas positioned:NSWindowAbove relativeTo:self.playerHoldView];
	}
	return _rander;
}

@end
