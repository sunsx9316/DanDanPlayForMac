//
//  JHProgressHUD.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
typedef NS_ENUM(NSUInteger, JHProgressHUDStyle) {
    value1,
    value2
};
@interface JHProgressHUD : NSView
+ (void)disMiss;
+ (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView dismissWhenClick:(BOOL)dismissWhenClick;
+ (void)showWithMessage:(NSString *)message parentView:(NSView *)parentView;
@end
