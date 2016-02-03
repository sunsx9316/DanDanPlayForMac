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

@interface MainViewController ()
@property (strong, nonatomic) BackGroundImageView *imgView;
@property (strong, nonatomic) LocalVideoModel *video;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self)weakSelf = self;
    [self.view addSubview: self.imgView];
    [self.imgView setUpBlock:^(NSString *filePath) {
        [weakSelf setUpWithFilePath: filePath];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPlayerViewController:) name:@"danMuChooseOver" object: nil];
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
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        for (int i = 0; i < 1000; ++i) {
//            DanMuDataModel *model = [[DanMuDataModel alloc] init];
//            model.time = i;
//            model.mode = 1;
//            model.color = 16777215;
//            model.fontSize = 25;
//            model.message = @(i).stringValue;
//            dic[@(i)] = @[model,model,model,model,model,model,model,model,model];
//        }
//        [NSApplication sharedApplication].mainWindow.contentViewController = [[PlayerViewController alloc] initWithLocaleVideo:self.video danMuDic:dic];
       
        [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithStoryboardID:@"MatchViewController" videoModel: self.video]];
    }else{
        [[NSAlert alertWithMessageText:@"然而文件并不存在，或者你用个文件夹在逗我" defaultButton:@"ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"⊂彡☆))∀`)"] runModal];
    }
}

#pragma mark - 私有方法

- (void)presentPlayerViewController:(NSNotification *)notification{
    [NSApplication sharedApplication].mainWindow.contentViewController = [[PlayerViewController alloc] initWithLocaleVideo:self.video danMuDic:notification.userInfo];
}

#pragma mark - 懒加载
- (BackGroundImageView *)imgView {
	if(_imgView == nil) {
		_imgView = [[BackGroundImageView alloc] initWithFrame:self.view.frame];
        [_imgView setWantsLayer: YES];
        _imgView.layer.backgroundColor = [NSColor blackColor].CGColor;
        _imgView.image = [NSImage imageNamed:@"home"];
        _imgView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [_imgView setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewHeightSizable|NSViewMinYMargin];
	}
	return _imgView;
}

@end
