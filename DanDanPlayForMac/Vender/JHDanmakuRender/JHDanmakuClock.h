//
//  JHDanmakuClock.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

typedef void(^timeBlock)(NSTimeInterval time);

@interface JHDanmakuClock : NSObject
@property(nonatomic,assign)CGFloat speed;
+ (instancetype)clockWithHandler:(timeBlock)block;
- (void)setCurrentTime:(NSTimeInterval)currentTime;
- (void)setOffsetTime:(NSTimeInterval)offsetTime;
- (void)start;
- (void)stop;
- (void)pause;
@end
