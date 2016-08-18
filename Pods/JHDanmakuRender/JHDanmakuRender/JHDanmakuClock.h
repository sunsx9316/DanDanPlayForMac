//
//  JHDanmakuClock.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHDanmakuHeader.h"
@class JHDanmakuClock;
@protocol JHDanmakuClockDelegate <NSObject>
- (void)danmakuClock:(JHDanmakuClock *)clock time:(NSTimeInterval)time;
@end

@interface JHDanmakuClock : NSObject
@property (weak, nonatomic) id<JHDanmakuClockDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval offsetTime;
- (void)setCurrentTime:(NSTimeInterval)currentTime;
- (void)start;
- (void)stop;
- (void)pause;
@end
