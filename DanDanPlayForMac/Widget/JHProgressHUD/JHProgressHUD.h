//
//  JHProgressHUD.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, JHProgressHUDStyle) {
    //菊花
    JHProgressHUDStyleValue1,
    //可以设置进度的饼图
    JHProgressHUDStyleValue2,
    //不停加载的进度条
    JHProgressHUDStyleValue3,
    //可以设置进度的进度条
    JHProgressHUDStyleValue4
};

@interface JHProgressHUD : NSView
+ (instancetype)shareProgressHUD;
- (void)showWithView:(NSView *)view;
- (void)showWithView:(NSView *)view anime:(BOOL)anime;
- (void)hideWithCompletion:(void(^)())completion;
- (void)hideWithCompletion:(void(^)())completion anime:(BOOL)anime;
@property (assign, nonatomic) JHProgressHUDStyle style;
/**
 *  进度 0 ~ 1
 */
@property (assign, nonatomic) float progress;
@property (assign, nonatomic, readonly) BOOL isShowing;
@property (strong, nonatomic) NSColor *indicatorColor;
@property (assign, nonatomic) CGSize indicatorSize;
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) NSColor *textColor;
@property (strong, nonatomic) NSFont *textFont;
@property (assign, nonatomic) BOOL hideWhenClick;
@end

