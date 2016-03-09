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
#import "JHVLCMedia.h"

#import "DanMuModel.h"
#import "MatchModel.h"
#import "LocalVideoModel.h"

#import "MatchViewModel.h"
#import "DanMuChooseViewModel.h"

#import "UpdateNetManager.h"

@interface MainViewController ()<NSWindowDelegate, NSUserNotificationCenterDelegate>
@property (strong, nonatomic) BackGroundImageView *imgView;
@property (strong, nonatomic) NSMutableArray <LocalVideoModel *>*videos;
@end

@implementation MainViewController
{
    NSString *_animateTitle;
    NSString *_episodeId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSApplication sharedApplication].mainWindow.title = @"弹弹play";
    [self.view addSubview: self.imgView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPlayerViewController:) name:@"danMuChooseOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainView) name:@"playOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMathchVideoName:) name:@"mathchVideo" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadOverNotification:) name:@"downloadOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openStreamVCChooseOver:) name:@"openStreamVCChooseOver" object: nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)setUpWithFilePath:(NSArray *)filePaths{
    [self.videos removeAllObjects];
    //路径为文件夹时 扫描文件夹下第一级目录
    for (NSString *fileURL in filePaths) {
        NSArray *contents = [self contentsOfDirectoryAtURL: fileURL];
        if (contents) {
            for (NSURL *url in contents) {
                [self.videos addObject: [[LocalVideoModel alloc] initWithFileURL:url]];
            }
        }else{
            [self.videos addObject: [[LocalVideoModel alloc] initWithFilePath: fileURL]];
        }
    }
    //啥也没有
    if (!self.videos.count) return;
    //没开启快速匹配
    if (![UserDefaultManager turnOnFastMatch]) {
        [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: self.videos.firstObject]];
        return;
    }
    
    
    [JHProgressHUD showWithMessage:@"解析中..." style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(300, 100) fontSize: 20 dismissWhenClick: NO];
    
    [[[MatchViewModel alloc] initWithModel:self.videos.firstObject] refreshWithModelCompletionHandler:^(NSError *error, MatchDataModel *model) {
        //episodeId存在 说明精确匹配
        if (model.episodeId) {
            _animateTitle = [NSString stringWithFormat:@"%@-%@", model.animeTitle, model.episodeTitle];
            [JHProgressHUD updateProgress: 50];
            [JHProgressHUD updateMessage: @"搜索弹幕..."];
            //搜索弹幕
            [[[DanMuChooseViewModel alloc] initWithVideoID: model.episodeId] refreshCompletionHandler:^(NSError *error) {
                //判断官方弹幕是否为空
                if (!error) {                    
                    [JHProgressHUD updateProgress: 100];
                    [JHProgressHUD updateMessage: @"解析视频..."];
                    _episodeId = model.episodeId;
                }else{
                    //快速匹配失败
                    [JHProgressHUD disMiss];
                    _episodeId = nil;
                    [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: self.videos.firstObject]];
                }
            }];
        }else{
            //快速匹配失败
            [JHProgressHUD disMiss];
            _episodeId = nil;
            [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: self.videos.firstObject]];
        }
    }];
}


#pragma mark - 私有方法
- (void)updateVersion{
    [UpdateNetManager latestVersionWithCompletionHandler:^(NSString *version, NSString *details, NSError *error) {
        float curentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
        //判断当前版本是否比现在版本小
        if (curentVersion < [version floatValue]) {
            [self presentViewControllerAsModalWindow:[[UpdateViewController alloc] initWithVersion:version details:details]];
        }
    }];
}

- (NSArray *)contentsOfDirectoryAtURL:(NSString *)path{
    BOOL isDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager fileExistsAtPath: path isDirectory:&isDirectory];
    if (!isDirectory) return nil;
    NSMutableArray *arr = [[fileManager contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants error:nil] mutableCopy];
    
    //移除一级目录下的文件夹
    for (NSInteger i = arr.count - 1; i >= 0; --i) {
        NSURL *url = arr[i];
        [fileManager fileExistsAtPath: url.path isDirectory:&isDirectory];
        if (isDirectory) [arr removeObjectAtIndex: i];
    }
    return arr;
}

#pragma mark 通知
- (void)downloadOverNotification:(NSNotification *)aNotification{
    //删除已经显示过的通知(已经存在用户的通知列表中的)
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    
    //删除已经在执行的通知(比如那些循环递交的通知)
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]){
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"弹弹play";
    notification.informativeText = [NSString stringWithFormat:@"下载完成 一共%@个", aNotification.userInfo[@"downloadCount"]];
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)changeMathchVideoName:(NSNotification *)notification{
    _animateTitle = notification.userInfo[@"animateTitle"];
}

- (void)presentPlayerViewController:(NSNotification *)notification{
    [JHProgressHUD disMiss];
    
    PlayerViewController *pvc = [[PlayerViewController alloc] initWithVideos: self.videos danMuDic:notification.userInfo matchName: _animateTitle episodeId:_episodeId];
    //赋值之后置空
    _animateTitle = nil;
    _episodeId = nil;
    [self addChildViewController: pvc];
    [self.view addSubview: pvc.view];
    [pvc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.imgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mathchVideo" object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"danMuChooseOver" object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"openStreamVCChooseOver" object: nil];
}

- (void)showMainView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPlayerViewController:) name:@"danMuChooseOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMathchVideoName:) name:@"mathchVideo" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openStreamVCChooseOver:) name:@"openStreamVCChooseOver" object: nil];
    self.imgView.frame = self.view.frame;
    [self.view addSubview: self.imgView];
}

- (void)openStreamVCChooseOver:(NSNotification *)notification{
    self.videos = notification.userInfo[@"videos"];
    _animateTitle = self.videos.firstObject.fileName;
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
        _imgView.layer.backgroundColor = [NSColor blackColor].CGColor;
        _imgView.image = [UserDefaultManager homeImg];
        
        __weak typeof (self)weakSelf = self;
        [self.imgView setupBlock:^(NSArray *filePath) {
            [weakSelf setUpWithFilePath: filePath];
        }];
        _imgView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [_imgView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    }
    return _imgView;
}

- (NSMutableArray <LocalVideoModel *> *)videos {
    if(_videos == nil) {
        _videos = [[NSMutableArray <LocalVideoModel *> alloc] init];
    }
    return _videos;
}

@end
