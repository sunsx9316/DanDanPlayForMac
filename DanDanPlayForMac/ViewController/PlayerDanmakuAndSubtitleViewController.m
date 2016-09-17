//
//  PlayerDanmakuAndSubtitleViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerDanmakuAndSubtitleViewController.h"

@implementation PlayerDanmakuAndSubtitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = RGBAColor(0, 0, 0, 0.5).CGColor;
    
    [self addChildViewController:self.danmakuVC];
    [self.view addSubview:_danmakuVC.view];
    
    [self addChildViewController:self.subtitleVC];
    [self.view addSubview:_subtitleVC.view];
    
    [_danmakuVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.equalTo(_subtitleVC.view.mas_left);
    }];
    
    [_subtitleVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.equalTo(_danmakuVC.view.mas_width);
    }];
}

- (void)startPlayNotice:(NSNotification *)sender {
    
}

#pragma mark - 懒加载
- (PlayerDanmakuViewController *)danmakuVC {
    if(_danmakuVC == nil) {
        _danmakuVC = [[PlayerDanmakuViewController alloc] initWithNibName:@"PlayerDanmakuViewController" bundle:nil];
    }
    return _danmakuVC;
}

- (PlayerSubtitleViewController *)subtitleVC {
    if(_subtitleVC == nil) {
        _subtitleVC = [[PlayerSubtitleViewController alloc] initWithNibName:@"PlayerSubtitleViewController" bundle:nil];
    }
    return _subtitleVC;
}

@end
