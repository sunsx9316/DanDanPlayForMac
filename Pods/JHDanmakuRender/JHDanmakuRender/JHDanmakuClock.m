//
//  JHDanmakuClock.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuClock.h"
#import "JHDisplayLink.h"
@interface JHDanmakuClock()<JHDisplayLinkDelegate>
@property (strong, nonatomic) JHDisplayLink *displayLink;
@property (strong, nonatomic) NSDate *previousDate;
@end

@implementation JHDanmakuClock
{
    BOOL _isStart;
    NSTimeInterval _currentTime;
    NSTimeInterval _offsetTime;
}

- (void)start{
    _isStart = YES;
    [self.displayLink start];
}

- (void)stop{
    _previousDate = nil;
    _currentTime = 0.0;
    [self.displayLink stop];
}

- (void)pause{
    _isStart = NO;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime{
    if (currentTime >= 0) {
        _currentTime = currentTime;
    }
}

- (void)setOffsetTime:(NSTimeInterval)offsetTime {
    _offsetTime = offsetTime;
}

- (void)updateTime{
    NSDate *date = [NSDate date];
    _currentTime += [date timeIntervalSinceDate:self.previousDate] * _isStart;
    self.previousDate = date;
    
    if ([self.delegate respondsToSelector:@selector(danmakuClock:time:)]) {
        [self.delegate danmakuClock:self time:_currentTime + _offsetTime];
    }
}

- (void)displayLink:(JHDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp{
    [self updateTime];
}

#pragma mark - 懒加载

- (NSDate *)previousDate {
    if(_previousDate == nil) {
        _previousDate = [NSDate date];
    }
    return _previousDate;
}

- (JHDisplayLink *)displayLink {
    if(_displayLink == nil) {
        _displayLink = [[JHDisplayLink alloc] init];
        _displayLink.delegate = self;
    }
    return _displayLink;
}

@end
