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

@interface MainViewController ()
@property (strong, nonatomic) BackGroundImageView *imgView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self)weakSelf = self;
    [self.view addSubview: self.imgView];
    [self.imgView setUpBlock:^(NSString *filePath) {
        [weakSelf setUpWithFilePath: filePath];
    }];
}

- (void)setUpWithFilePath:(NSString *)filePath{
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory:&isDirectory];
    //是文件才开始解析
    if (!isDirectory) {
        
        [self presentViewControllerAsSheet: [[MatchViewController alloc] initWithStoryboardID:@"MatchViewController" videoModel: [[LocalVideoModel alloc] initWithFilePath: filePath]]];
    }else{
        [[NSAlert alertWithMessageText:@"然而文件并不存在，或者你用个文件夹在逗我" defaultButton:@"ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"⊂彡☆))∀`)"] runModal];
    }
}

#pragma mark - 懒加载
- (BackGroundImageView *)imgView {
	if(_imgView == nil) {
		_imgView = [[BackGroundImageView alloc] initWithFrame:self.view.frame];
        [_imgView setWantsLayer: YES];
        _imgView.layer.backgroundColor = [NSColor blackColor].CGColor;
        _imgView.image = [NSImage imageNamed:@"home"];
        _imgView.imageScaling = NSImageScaleProportionallyDown;
        [_imgView setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewHeightSizable|NSViewMinYMargin];
	}
	return _imgView;
}

@end
