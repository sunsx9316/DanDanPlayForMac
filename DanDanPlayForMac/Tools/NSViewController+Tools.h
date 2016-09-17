//
//  NSViewController+dismiss.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSViewController (Tools)
+ (instancetype)viewController;
- (NSViewController *)keyWindowsViewController;
@end
