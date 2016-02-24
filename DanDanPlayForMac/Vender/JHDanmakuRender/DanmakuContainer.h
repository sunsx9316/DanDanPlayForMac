//
//  DanmakuContainer.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScrollDanmaku.h"
#import "FloatDanmaku.h"
/**
 *  弹幕的容器 用来绘制弹幕
 */
@interface DanmakuContainer : NSTextField
@property (assign, nonatomic) CGPoint originalPosition;
@property (strong, nonatomic) NSDictionary *globalAttributedDic;
@property (strong, nonatomic) NSFont *globalFont;
- (ParentDanmaku *)danmaku;
- (instancetype)initWithDanmaku:(ParentDanmaku *)danmaku;
- (void)setWithDanmaku:(ParentDanmaku *)danmaku;
/**
 *  更新位置
 *
 *  @param time 当前时间
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositionWithTime:(NSTimeInterval)time;
@end
