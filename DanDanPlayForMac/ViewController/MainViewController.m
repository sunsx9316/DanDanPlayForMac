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

#import "DanmakuModel.h"
#import "MatchModel.h"
#import "LocalVideoModel.h"

#import "MatchViewModel.h"
#import "DanMuChooseViewModel.h"

#import "UpdateNetManager.h"
#import "SliderAnimate.h"

@interface MainViewController ()<NSWindowDelegate, NSUserNotificationCenterDelegate>
@property (strong, nonatomic) BackGroundImageView *imgView;
@property (strong, nonatomic) NSMutableOrderedSet *videos;
@property (strong, nonatomic) PlayerViewController *playerViewController;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSApplication sharedApplication].mainWindow.title = [ToolsManager appName];
    [self.view addSubview: self.imgView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadOverNotification:) name:@"DOWNLOAD_OVER" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHomgImg:) name:@"CHANGE_HOME_IMG" object:nil];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    //推出更新窗口
    [self updateVersion];
    //推出推荐窗口
    [self showRecommedVC];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

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
    [UserDefaultManager shareUserDefaultManager].currentVideoModel = videoModel;
    //没开启快速匹配
    if (![UserDefaultManager shareUserDefaultManager].turnOnFastMatch) {
        MatchViewController *vc = [MatchViewController viewController];
        vc.videoModel = videoModel;
        [self presentViewControllerAsSheet: vc];
        return;
    }
    
    [JHProgressHUD showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeAnalyze].message style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(300, 100) fontSize: 20 dismissWhenClick: NO];
    
    MatchViewModel *vm = [[MatchViewModel alloc] init];
    vm.videoModel = videoModel;
    [vm refreshWithCompletionHandler:^(NSError *error, MatchDataModel *model) {
        //episodeId存在 说明精确匹配
        if (model.episodeId) {
            videoModel.matchTitle = [NSString stringWithFormat:@"%@-%@", model.animeTitle, model.episodeTitle];
            [JHProgressHUD updateProgress: 0.5];
            [JHProgressHUD updateMessage: [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeAnalyzeVideo].message];
            
            DanMuChooseViewModel *vm = [[DanMuChooseViewModel alloc] init];
            vm.videoId = model.episodeId;
            //搜索弹幕
            [vm refreshCompletionHandler:^(NSError *error) {
                //判断官方弹幕是否为空
                if (!error) {                    
                    [JHProgressHUD updateProgress: 1];
                    [JHProgressHUD updateMessage: [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloadingDanmaku].message];
                    videoModel.episodeId = model.episodeId;
                }
                else {
                    //快速匹配失败
                    [JHProgressHUD disMiss];
                    videoModel.episodeId = nil;
                    MatchViewController *vc = [MatchViewController viewController];
                    vc.videoModel = videoModel;
                    [self presentViewControllerAsSheet: vc];
                }
            }];
        }
        else {
            //快速匹配失败
            [JHProgressHUD disMiss];
            videoModel.episodeId = nil;
            MatchViewController *vc = [MatchViewController viewController];
            vc.videoModel = videoModel;
            [self presentViewControllerAsSheet: vc];
        }
    }];
}


#pragma mark - 私有方法
//检查更新
- (void)updateVersion {
    //没开启自动检查更新功能
    if (![UserDefaultManager shareUserDefaultManager].cheakDownLoadInfoAtStart) return;
    
    [UpdateNetManager latestVersionWithCompletionHandler:^(NSString *version, NSString *details, NSString *hash, NSError *error) {
        //判断当前版本是否比现在版本小
        if ([ToolsManager appVersion] < [version floatValue]) {
            [self presentViewControllerAsModalWindow:[UpdateViewController viewControllerWithVersion:version details:details hash:hash]];
        }
    }];
}
//显示推荐窗口
- (void)showRecommedVC {
    if ([UserDefaultManager shareUserDefaultManager].showRecommedInfoAtStart) {
        [self presentViewControllerAsModalWindow:[[RecommendViewController alloc] init]];
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

#pragma mark 通知
- (void)downloadOverNotification:(NSNotification *)aNotification {
    //删除已经显示过的通知(已经存在用户的通知列表中的)
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    
    //删除已经在执行的通知(比如那些循环递交的通知)
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]){
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = [ToolsManager appName];
    notification.informativeText = [NSString stringWithFormat:@"下载完成 一共%@个", aNotification.userInfo[@"downloadCount"]];
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)startPlayNotice:(NSNotification *)sender {
    [JHProgressHUD disMiss];
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
        [self showMainView];
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
        [self.imgView removeFromSuperview];
    }];
    
    [self presentViewController:self.playerViewController animator:anima];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"START_PLAY" object: nil];
}

- (void)showMainView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayNotice:) name:@"START_PLAY" object: nil];
    self.imgView.frame = self.view.frame;
    [self.view addSubview:self.imgView positioned:NSWindowBelow relativeTo:self.playerViewController.view];
}

- (void)changeHomgImg:(NSNotification *)notification{
    self.imgView.image = notification.object;
}

#pragma mark - NSUserNotificationDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    //强制显示
    return YES;
}

#pragma mark - 懒加载
- (BackGroundImageView *)imgView {
    if(_imgView == nil) {
        _imgView = [[BackGroundImageView alloc] initWithFrame:self.view.frame];
        [_imgView setWantsLayer: YES];
        _imgView.backgroundColor = [NSColor blackColor];
        _imgView.image = [[NSImage alloc] initWithContentsOfFile:[UserDefaultManager shareUserDefaultManager].homeImgPath];
        
        __weak typeof (self)weakSelf = self;
        [self.imgView setFilePickBlock:^(NSArray *filePath) {
            [weakSelf setUpWithFilePath: filePath];
        }];
        _imgView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [_imgView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    }
    return _imgView;
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
	}
	return _playerViewController;
}

@end
