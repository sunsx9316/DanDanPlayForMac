//
//  JHDanmakuEngine.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ParentDanmaku.h"
#import "JHDanmakuCanvas.h"

@interface JHDanmakuEngine : NSObject
//是否开启回退功能
@property (assign, nonatomic) BOOL turnonBackFunction;
@property (strong, nonatomic) JHDanmakuCanvas *canvas;
//把窗口平分为多少份 默认0 自动调整
@property (assign, nonatomic) NSInteger channelCount;
//当前时间
@property (assign, nonatomic) NSTimeInterval currentTime;
//全局文字风格字典 默认不使用 会覆盖个体设置
@property (strong, nonatomic) NSDictionary *globalAttributedDic;
//全局字体 默认不使用 会覆盖个体设置
@property (strong, nonatomic) NSFont *globalFont;
//全局屏蔽弹幕类型 @[方向] 比如@[@(scrollDanmakuDirectionR2L),@(floatDanmakuDirectionT2B)]
@property (strong, nonatomic) NSMutableSet *globalFilterDanmaku;
//默认1.0
- (void)setSpeed:(CGFloat)speed;
- (void)start;
- (void)stop;
- (void)pause;
/**
 *  不需要回退功能时使用
 *
 *  @param danmaku 单个弹幕
 */
- (void)addDanmaku:(ParentDanmaku *)danmaku;
/**
 *  需要回退功能时使用 必须一次性加载所有的弹幕 弹幕需要设置出现时间
 *
 *  @param danmakus 弹幕数组
 */
- (void)addAllDanmakus:(NSArray <ParentDanmaku *>*)danmakus;

@end
