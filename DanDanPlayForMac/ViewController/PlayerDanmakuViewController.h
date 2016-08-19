//
//  PlayerDanmakuViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayerDanmakuViewController : NSViewController
/**
 *  关闭弹幕面板回调
 */
@property (copy, nonatomic) void(^hideDanMuAndCloseCallBack)(NSInteger num, NSInteger status);
/**
 *  调整弹幕尺寸回调
 */
@property (copy, nonatomic) void(^adjustDanmakuFontSizeCallBack)(CGFloat value);
/**
 *  调整弹幕速度回调
 */
@property (copy, nonatomic) void(^adjustDanmakuSpeedCallBack)(CGFloat value);
/**
 *  调整弹幕透明度回调
 */
@property (copy, nonatomic) void(^adjustDanmakuOpacityCallBack)(CGFloat value);
/**
 *  调整弹幕偏移时间回调
 */
@property (copy, nonatomic) void(^adjustDanmakuTimeOffsetCallBack)(NSInteger value);
/**
 *  重新选择弹幕回调
 */
@property (copy, nonatomic) void(^showSearchViewControllerCallBack)();
/**
 *  加载本地弹幕回调
 */
@property (copy, nonatomic) void(^reloadLocaleDanmakuCallBack)();
@end
