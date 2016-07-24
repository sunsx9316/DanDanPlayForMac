//
//  JHSubtitle.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubtitleHeader.h"

@class JHSubTitleContainer;
@interface JHSubtitle : NSObject
@property (assign, nonatomic) NSTimeInterval appearTime;
@property (assign, nonatomic) NSTimeInterval disappearTime;
@property (strong, nonatomic) NSAttributedString *attributedString;

/**
 *  更新位置
 *
 *  @param time      当前时间
 *  @param container 容器
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(JHSubTitleContainer *)container;
/**
 *  字幕时长
 *
 *  @return 时长
 */
- (NSTimeInterval)during;
/**
 *  计算弹幕初始位置
 *
 *  @param arr          字幕数组
 *  @param rect         画布尺寸
 *  @param subTitleSize 字幕尺寸
 *
 *  @return 初始位置
 */
- (CGPoint)originalPositonWithContainerArr:(NSArray <JHSubTitleContainer *>*)arr contentRect:(CGRect)rect subTitleSize:(CGSize)subTitleSize;
@end
