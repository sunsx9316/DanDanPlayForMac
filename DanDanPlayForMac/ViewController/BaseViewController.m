//
//  BaseViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayNotice:) name:@"START_PLAY" object: nil];
}

- (void)startPlayNotice:(NSNotification *)sender {
    [self dismissController:self];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

@end
