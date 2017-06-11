//
//  MainViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "MainViewController.h"
#import "MatchViewController.h"
#import "PlayerViewController.h"
#import "UpdateViewController.h"
#import "BackGroundImageView.h"
#import "RecommendViewController.h"
#import "PlayerListViewController.h"

#import "DanmakuModel.h"
#import "MatchModel.h"
#import "LocalVideoModel.h"

#import "MatchViewModel.h"
#import "DanMuChooseViewModel.h"

#import "UpdateNetManager.h"
#import "SliderAnimate.h"
#import "POPMasSpringAnimation.h"
#import "NSUserNotificationCenter+Tools.h"

#import <JPEngine.h>

@interface MainViewController ()<NSWindowDelegate, NSUserNotificationCenterDelegate>
@property (strong, nonatomic) NSMutableOrderedSet *videos;
@property (strong, nonatomic) PlayViewModel *vm;
//承载背景图 播放列表的视图
@property (strong, nonatomic) NSView *plceHolderView;
@property (strong, nonatomic) BackGroundImageView *bgImgView;
@property (strong, nonatomic) PlayerViewController *playerViewController;
//控制播放列表面板显示/隐藏的按钮
@property (strong, nonatomic) NSButton *controlPlayListControllerViewButton;
//播放列表控制器
@property (strong, nonatomic) PlayerListViewController *playerListViewController;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end

@implementation MainViewController
{
    NSTimer *_autoHideTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    [NSApplication sharedApplication].mainWindow.title = [ToolsManager appName];
    [self.view addTrackingArea:self.trackingArea];
    self.plceHolderView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [[UserDefaultManager shareUserDefaultManager] addObserver:self forKeyPath:@"videoListOrderedSet" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadOverNotification:) name:@"DOWNLOAD_OVER" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHomgImg:) name:@"CHANGE_HOME_IMG" object:nil];
    
    _autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:AUTO_HIDE_TIME target:self selector:@selector(autoHidePlayListControlView) userInfo:nil repeats:NO];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    //推出更新窗口
    [self updateVersion];
    //推出推荐窗口
    [self showRecommedVC];
}

- (void)dealloc {
    [self.view removeTrackingArea:self.trackingArea];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UserDefaultManager shareUserDefaultManager] removeObserver:self forKeyPath:@"videoListOrderedSet"];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    [_autoHideTimer invalidate];
    _autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:AUTO_HIDE_TIME target:self selector:@selector(autoHidePlayListControlView) userInfo:nil repeats:NO];
    self.controlPlayListControllerViewButton.animator.alphaValue = 1;
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.controlPlayListControllerViewButton.state) {
        _controlPlayListControllerViewButton.state = 0;
        [self clickPlayListViewButton:_controlPlayListControllerViewButton];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self.playerListViewController.tableView reloadData];
}

#pragma mark - 私有方法
- (void)setUpWithFilePath:(NSArray *)filePaths {
    [self.videos removeAllObjects];
    //路径为文件夹时 扫描文件夹下第一级目录
    for (NSString *fileURL in filePaths) {
        NSArray *contents = [self contentsOfDirectoryAtURL: fileURL];
        if (contents.count) {
            [self.videos addObjectsFromArray:contents];
        }
    }
    //啥也没有
    if (!self.videos.count) return;
    
    LocalVideoModel *videoModel = self.videos.firstObject;
    //记录当前分析的模型
    [ToolsManager shareToolsManager].currentVideoModel = videoModel;
    //没开启快速匹配
    if (![UserDefaultManager shareUserDefaultManager].turnOnFastMatch) {
        MatchViewController *vc = [MatchViewController viewController];
        vc.videoModel = videoModel;
        [self presentViewControllerAsSheet: vc];
        return;
    }
    
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeAnalyze].message style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(300, 100) fontSize: 20 hideWhenClick: NO];
    
    MatchViewModel *vm = [[MatchViewModel alloc] init];
    vm.videoModel = videoModel;
    [vm refreshWithCompletionHandler:^(NSError *error, MatchDataModel *model) {
        //episodeId存在 说明精确匹配
        if (model.episodeId) {
            videoModel.matchTitle = [NSString stringWithFormat:@"%@-%@", model.animeTitle, model.episodeTitle];
            [JHProgressHUD shareProgressHUD].progress = 0.5;
            [JHProgressHUD shareProgressHUD].text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeAnalyzeVideo].message;
            
            DanMuChooseViewModel *vm = [[DanMuChooseViewModel alloc] init];
            vm.videoId = model.episodeId;
            //搜索弹幕
            [vm refreshCompletionHandler:^(NSError *error) {
                //判断官方弹幕是否为空
                if (!error) {                    
                    [JHProgressHUD shareProgressHUD].progress = 1;
                    [JHProgressHUD shareProgressHUD].text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloadingDanmaku].message;
                    videoModel.episodeId = model.episodeId;
                }
                else {
                    //快速匹配失败
                    [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
                    videoModel.episodeId = nil;
                    MatchViewController *vc = [MatchViewController viewController];
                    vc.videoModel = videoModel;
                    [self presentViewControllerAsSheet: vc];
                }
            }];
        }
        else {
            //快速匹配失败
            [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
            videoModel.episodeId = nil;
            MatchViewController *vc = [MatchViewController viewController];
            vc.videoModel = videoModel;
            [self presentViewControllerAsSheet: vc];
        }
    }];
}

- (void)autoHidePlayListControlView {
    self.controlPlayListControllerViewButton.animator.alphaValue = 0;
}

//检查更新
- (void)updateVersion {
    //没开启自动检查更新功能
    if (![UserDefaultManager shareUserDefaultManager].cheakDownLoadInfoAtStart) return;
    
    [UpdateNetManager latestVersionWithCompletionHandler:^(VersionModel *model) {
        //判断当前版本是否比服务器版本小
        if ([ToolsManager appVersion] < model.version.floatValue) {
            [self presentViewControllerAsModalWindow:[UpdateViewController viewControllerWithModel:model]];
        }
        else {
            VersionModel *currentVersionModel = [UserDefaultManager shareUserDefaultManager].versionModel;
            currentVersionModel.patchName = model.patchName;
            [UserDefaultManager shareUserDefaultManager].versionModel = currentVersionModel;
            //检查补丁文件
            NSString *patchPath = [[UserDefaultManager shareUserDefaultManager].patchPath stringByAppendingPathComponent:model.patchName];
            //不存在说明没下载过
            if (![[NSFileManager defaultManager] fileExistsAtPath:patchPath isDirectory:nil]) {
                [UpdateNetManager downPatchWithVersion:[NSString stringWithFormat:@"%@", model.version] hash:model.patchName completionHandler:^(NSURL *filePath, DanDanPlayErrorModel *error) {
                    [JPEngine startEngine];
                    NSString *script = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
                    //防止崩溃
                    if ([script rangeOfString:@"<html>"].location == NSNotFound) {
                        [JPEngine evaluateScript:script];
                    }
                }];
            }
        }
    }];
}

//显示推荐窗口
- (void)showRecommedVC {
    if ([UserDefaultManager shareUserDefaultManager].showRecommedInfoAtStart) {
        [self presentViewControllerAsModalWindow:[RecommendViewController viewController]];
    }
}

- (NSArray *)contentsOfDirectoryAtURL:(NSString *)path {
    BOOL isDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path isDirectory:&isDirectory]) {
        if (!isDirectory) return @[[[LocalVideoModel alloc] initWithFileURL:[NSURL fileURLWithPath:path]]];
    }
    NSMutableArray *arr = [[fileManager contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants error:nil] mutableCopy];
    
    //移除一级目录下的文件夹
    for (NSInteger i = arr.count - 1; i >= 0; --i) {
        NSURL *url = arr[i];
        if ([fileManager fileExistsAtPath: url.path isDirectory:&isDirectory]) {
            if (isDirectory) [arr removeObjectAtIndex: i];
            else arr[i] = [[LocalVideoModel alloc] initWithFileURL:url];
        }
    }
    return arr;
}

- (void)clickPlayListViewButton:(NSButton *)sender {
    POPMasSpringAnimation *animate = [POPMasSpringAnimation animationWithPropertyType:POPMasAnimationTypeLeft];
    animate.beginTime = CACurrentMediaTime();
    animate.springBounciness = 10;
    
    if (sender.state) {
        animate.fromValue = @(-self.playerListViewController.view.frame.size.width);
        animate.toValue = @0;
    }
    else {
        animate.fromValue = @0;
        animate.toValue = @(-self.playerListViewController.view.frame.size.width);
    }
    [self.playerListViewController.view pop_addAnimation:animate forKey:@"PLAYER_LIST_ANIMA"];
}

#pragma mark 通知
- (void)downloadOverNotification:(NSNotification *)aNotification {
    [NSUserNotificationCenter postMatchMessageWithTitle:[ToolsManager appName] subtitle:nil informativeText:aNotification.object delegate:self];
}



- (void)startPlayNotice:(NSNotification *)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"START_PLAY" object: nil];
    
    [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
    //去重
    [self.videos addObjectsFromArray:sender.object];
    [self.playerViewController addVideos:_videos.array];
    [_videos removeAllObjects];
    
    @weakify(self)
    SliderAnimate *anima = [[SliderAnimate alloc] init];
    anima.direction = SliderAnimateDirectionB2T;
    [anima setDismissWillBeginCompletion:^{
        @strongify(self)
        if (!self) return;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayNotice:) name:@"START_PLAY" object: nil];
        [self.view addSubview:self.plceHolderView positioned:NSWindowBelow relativeTo:self.playerViewController.view];
        [self.plceHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }];
    
    [anima setDismissDidEndCompletion:^{
        @strongify(self)
        if (!self) return;
        
        self.playerViewController = nil;
    }];
    
    [anima setPresentationDidEndCompletion:^{
        @strongify(self)
        if (!self) return;
        [self.playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.plceHolderView removeFromSuperview];
    }];
    
    [self presentViewController:self.playerViewController animator:anima];
}

- (void)changeHomgImg:(NSNotification *)notification{
    self.bgImgView.image = notification.object;
}

#pragma mark - NSUserNotificationDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    //强制显示
    return YES;
}

#pragma mark - 懒加载
- (BackGroundImageView *)bgImgView {
    if(_bgImgView == nil) {
        _bgImgView = [[BackGroundImageView alloc] initWithFrame:self.view.bounds];
        [_bgImgView setWantsLayer: YES];
        _bgImgView.backgroundColor = [NSColor blackColor];
        _bgImgView.image = [[NSImage alloc] initWithContentsOfFile:[UserDefaultManager shareUserDefaultManager].homeImgPath];
        @weakify(self)
        [_bgImgView setFilePickBlock:^(NSArray *filePath) {
            @strongify(self)
            if (!self) return;
            
            [self setUpWithFilePath: filePath];
        }];
        _bgImgView.imageScaling = NSImageScaleProportionallyDown;
        _bgImgView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    return _bgImgView;
}

- (NSMutableOrderedSet *)videos {
    if(_videos == nil) {
        _videos = [[NSMutableOrderedSet alloc] init];
    }
    return _videos;
}

- (PlayerViewController *)playerViewController {
	if(_playerViewController == nil) {
		_playerViewController = [[PlayerViewController alloc] init];
        _playerViewController.vm = self.vm;
	}
	return _playerViewController;
}

- (PlayerListViewController *)playerListViewController {
    if(_playerListViewController == nil) {
        _playerListViewController = [[PlayerListViewController alloc] initWithNibName:@"PlayerListViewController" bundle:nil];
        _playerListViewController.vm = self.vm;
        @weakify(self)
        //点击行
        [_playerListViewController setDoubleClickRowCallBack:^(NSUInteger row) {
            @strongify(self)
            if (!self) return;
            
            self.vm.currentIndex = row;
            id<VideoModelProtocol> video = self.vm.currentVideoModel;
            if (video) {
                NSNotification *notification = [NSNotification notificationWithName:@"START_PLAY" object:@[video]];
                [self startPlayNotice:notification];
            }
        }];
        [self addChildViewController:_playerListViewController];
    }
    return _playerListViewController;
}

- (NSButton *)controlPlayListControllerViewButton {
    if(_controlPlayListControllerViewButton == nil) {
        _controlPlayListControllerViewButton = [[NSButton alloc] init];
        _controlPlayListControllerViewButton.bordered = NO;
        _controlPlayListControllerViewButton.bezelStyle = NSTexturedRoundedBezelStyle;
        [_controlPlayListControllerViewButton setImage: [NSImage imageNamed:@"show_play_list_controller"]];
        [_controlPlayListControllerViewButton setTarget: self];
        [_controlPlayListControllerViewButton setAction: @selector(clickPlayListViewButton:)];
    }
    return _controlPlayListControllerViewButton;
}

- (NSView *)plceHolderView {
    if(_plceHolderView == nil) {
        _plceHolderView = [[NSView alloc] initWithFrame:self.view.bounds];
        
        [_plceHolderView addSubview: self.bgImgView];
        [_plceHolderView addSubview:self.controlPlayListControllerViewButton positioned:NSWindowAbove relativeTo: self.bgImgView];
        [_plceHolderView addSubview: self.playerListViewController.view positioned:NSWindowAbove relativeTo:self.bgImgView];
        
        [_playerListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.top.bottom.mas_equalTo(0);
            make.left.mas_offset(-300);
        }];
        
        [_controlPlayListControllerViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(100);
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.playerListViewController.view.mas_right);
        }];
        
        [self.view addSubview:_plceHolderView];
    }
    return _plceHolderView;
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseMoved | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

- (PlayViewModel *)vm {
	if(_vm == nil) {
		_vm = [[PlayViewModel alloc] init];
	}
	return _vm;
}

@end
