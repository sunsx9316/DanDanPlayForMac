//
//  JHDanmakuClock.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSubtitleHeader.h"

@class JHSubTitleClock;
@protocol JHSubTitleClockDelegate <NSObject>
- (void)sutitleClock:(JHSubTitleClock *)clock time:(NSTimeInterval)time;
@end

@interface JHSubTitleClock : NSObject
@property (weak, nonatomic) id<JHSubTitleClockDelegate> delegate;
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) NSTimeInterval offsetTime;;
- (void)setCurrentTime:(NSTimeInterval)currentTime;
- (void)start;
- (void)stop;
- (void)pause;
@end
