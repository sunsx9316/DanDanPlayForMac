//
//  JHDanmakuEngine.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ParentDanmaku.h"
#import "JHDanmakuCanvas.h"
#import "ParentDanmaku.h"

@interface JHDanmakuEngine : NSObject
//是否开启回退功能
@property (assign, nonatomic) BOOL turnonBackFunction;
@property (strong, nonatomic) JHDanmakuCanvas *canvas;
//把窗口平分为多少份 默认0 自动调整
@property (assign, nonatomic) NSInteger channelCount;
//当前时间
@property (assign, nonatomic) NSTimeInterval currentTime;
//偏移时间 让弹幕偏移一般设置这个就行
@property (assign, nonatomic) NSTimeInterval offsetTime;
//全局文字风格字典 默认不使用 会覆盖个体设置
@property (strong, nonatomic) NSDictionary *globalAttributedDic;
//全局字体 默认不使用 会覆盖个体设置 方便更改字体大小
@property (strong, nonatomic) JHFont *globalFont;
//全局字体边缘特效 默认不使用 会覆盖个体设置
@property (strong, nonatomic) NSNumber *globalShadowStyle;
//全局屏蔽弹幕类型 @[方向] 比如@[@(scrollDanmakuDirectionR2L),@(floatDanmakuDirectionT2B)]
@property (strong, nonatomic) NSMutableSet *globalFilterDanmaku;
//全局速度 默认1.0
- (void)setSpeed:(float)speed;
//暂停状态就是恢复运动
- (void)start;
- (void)stop;
- (void)pause;
/**
 *  不需要回退功能时使用
 *
 *  @param danmaku 单个弹幕
 */
- (void)sendDanmaku:(ParentDanmaku *)danmaku;
/**
 *  需要回退功能时使用 必须一次性加载所有的弹幕 弹幕需要设置出现时间 实际上就是设置时间字典
 *  与addAllDanmakusDic方法作用一样
 *
 *  @param danmakus 弹幕数组
 */
- (void)sendAllDanmakus:(NSArray <ParentDanmaku *>*)danmakus;
/**
 * 需要回退功能时使用 必须一次性加载所有的弹幕 弹幕需要设置出现时间
 * 字典按照整秒分类 比如@{@(1):@[obj1,obj2...], @(2):@[obj1,obj2...]}
 *  @param danmakus 弹幕字典
 */
- (void)sendAllDanmakusDic:(NSDictionary <NSNumber *,NSArray <ParentDanmaku *>*>*)danmakus;
@end
