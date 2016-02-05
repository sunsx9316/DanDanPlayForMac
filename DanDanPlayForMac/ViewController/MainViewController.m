//
//  MainViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "MainViewController.h"
#import "LocalVideoModel.h"
#import "MatchViewController.h"
#import "BackGroundImageView.h"
#import "PlayerViewController.h"
#import "DanMuModel.h"
#import "JHVLCMedia.h"

#import "MatchViewModel.h"
#import "DanMuChooseViewModel.h"

@interface MainViewController ()<NSWindowDelegate>
@property (strong, nonatomic) BackGroundImageView *imgView;
@property (strong, nonatomic) LocalVideoModel *video;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSApplication sharedApplication].mainWindow.title = @"弹弹play";
    [self.view addSubview: self.imgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPlayerViewController:) name:@"danMuChooseOver" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImgView) name:@"playOver" object: nil];
    
}


- (void)viewWillDisappear{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)setUpWithFilePath:(NSString *)filePath{
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory:&isDirectory];
    //是文件才开始解析
    if (!isDirectory) {
        self.video = [[LocalVideoModel alloc] initWithFilePath: filePath];
       // [self presentPlayerViewController: nil];
        [JHProgressHUD showWithMessage:@"解析中..." style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:NSMakeSize(100, 100) fontSize: 20 dismissWhenClick: NO];
        
        [[[MatchViewModel alloc] initWithModel:self.video] refreshWithModelCompletionHandler:^(NSError *error, NSString *episodeId) {
            //episodeId存在 说明精确匹配
            if (episodeId) {
                [JHProgressHUD updateProgress: 50];
                [JHProgressHUD updateMessage: @"搜索弹幕..."];
                //搜索弹幕
                [[[DanMuChooseViewModel alloc] initWithVideoID: episodeId] refreshCompletionHandler:^(NSError *error) {
                    [JHProgressHUD updateProgress: 100];
                    [JHProgressHUD updateMessage: @"解析视频..."];
                }];
            }else{
                [JHProgressHUD disMiss];
                [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithVideoModel: self.video]];
            }
        }];
    }else{
        [[NSAlert alertWithMessageText:@"然而文件并不存在，或者你用个文件夹在逗我" defaultButton:@"ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"⊂彡☆))∀`)"] runModal];
    }
}

#pragma mark - 私有方法

- (void)presentPlayerViewController:(NSNotification *)notification{
    [[[JHVLCMedia alloc] initWithURL: [NSURL fileURLWithPath: self.video.filePath]] parseWithBlock:^(VLCMedia *aMedia) {
        [JHProgressHUD disMiss];
        PlayerViewController *pvc = [[PlayerViewController alloc] initWithLocaleVideo: self.video vlcMedia:aMedia danMuDic:notification.userInfo];
        [self addChildViewController: pvc];
        [self.view addSubview: pvc.view];
        [pvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.imgView removeFromSuperview];
    }];
}

- (void)showImgView{
    self.imgView.frame = self.view.frame;
    [self.view addSubview: self.imgView];
}

#pragma mark - 懒加载
- (BackGroundImageView *)imgView {
    if(_imgView == nil) {
        _imgView = [[BackGroundImageView alloc] initWithFrame:self.view.frame];
        [_imgView setWantsLayer: YES];
        _imgView.layer.backgroundColor = [NSColor blackColor].CGColor;
        _imgView.image = [NSImage imageNamed:@"home"];
        __weak typeof (self)weakSelf = self;
        [self.imgView setUpBlock:^(NSString *filePath) {
            [weakSelf setUpWithFilePath: filePath];
        }];
        _imgView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [_imgView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    }
    return _imgView;
}

@end
