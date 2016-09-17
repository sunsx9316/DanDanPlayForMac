//
//  NSViewController+dismiss.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSViewController+Tools.h"

@implementation NSViewController (Tools)
+ (instancetype)viewController {
    NSViewController *vc = kViewControllerWithId(NSStringFromClass([self class]));
    if (!vc) {
        vc = [[[self class] alloc] init];
    }
    return vc;
}

- (NSViewController *)keyWindowsViewController {
    return NSApp.keyWindow.contentViewController;
}

@end
