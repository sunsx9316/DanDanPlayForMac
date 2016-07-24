//
//  DanmakuContainer.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//


#import "JHSubtitle.h"
#import "JHSubtitleHeader.h"
/**
 *  字幕的容器 用来绘制字幕
 */
@interface JHSubTitleContainer : JHLabel
@property (assign, nonatomic) CGPoint originalPosition;
@property (strong, nonatomic) NSDictionary *globalAttributedDic;
//@property (strong, nonatomic) JHFont *globalFont;
- (JHSubtitle *)subTitle;
- (instancetype)initWithSubTitle:(JHSubtitle *)subTitle;
- (void)setWithSubTitle:(JHSubtitle *)subTitle;
/**
 *  更新位置
 *
 *  @param time 当前时间
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositionWithTime:(NSTimeInterval)time;
@end
