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
/**
 *  隐藏
 */
+ (void)disMiss;
/**
 *  更新进度 当style为 JHProgressHUDStyleValue2 JHProgressHUDStyleValue4时有效
 *
 *  @param progress 进度 0~100
 */
+ (void)updateProgress:(CGFloat)progress;
/**
 *  更新文字
 *
 *  @param message 文字
 */
+ (void)updateMessage:(NSString *)message;
/**
 *  显示hud
 *
 *  @param message          显示的消息
 *  @param style            显示风格
 *  @param parentView       父视图
 *  @param size             指示器尺寸
 *  @param fontSize         文字尺寸
 *  @param dismissWhenClick 点击时消失
 */
+ (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView indicatorSize:(NSSize)size fontSize:(CGFloat)fontSize dismissWhenClick:(BOOL)dismissWhenClick;
/**
 *  显示hud
 *
 *  @param message          显示的消息
 *  @param style            显示风格
 *  @param parentView       父视图
 *  @param dismissWhenClick 点击时消失
 */
+ (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)
parentView dismissWhenClick:(BOOL)dismissWhenClick;

/**
 *  显示hud
 *
 *  @param message    显示的消息
 *  @param parentView 父视图
 */
+ (void)showWithMessage:(NSString *)message parentView:(NSView *)parentView;
@end
