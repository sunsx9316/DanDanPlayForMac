//
//  JHDanmakuClock.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubTitleClock.h"
#import "JHSubTitleDisplayLink.h"
@interface JHSubTitleClock()<JHSubTitleDisplayLinkDelegate>
@property (strong, nonatomic) JHSubTitleDisplayLink *displayLink;
@property (strong, nonatomic) NSDate *previousDate;
@end

@implementation JHSubTitleClock
{
    BOOL _isStart;
    NSTimeInterval _currentTime;
    NSTimeInterval _offsetTime;
}

- (void)start {
    _isStart = YES;
    [self.displayLink start];
}

- (void)stop {
    _previousDate = nil;
    _currentTime = 0.0;
    [self.displayLink stop];
}

- (void)pause {
    _isStart = NO;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime >= 0) {
        _currentTime = currentTime;
    }
}

- (void)setOffsetTime:(NSTimeInterval)offsetTime {
    _offsetTime = offsetTime;
}

- (void)updateTime {
    NSDate *date = [NSDate date];
    _currentTime += [date timeIntervalSinceDate:self.previousDate] * _isStart * _speed;
    self.previousDate = date;
    
    if ([self.delegate respondsToSelector:@selector(sutitleClock:time:)]) {
        [self.delegate sutitleClock:self time:_currentTime + _offsetTime];
    }
}

- (void)displayLink:(JHSubTitleDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp {
    [self updateTime];
}

#pragma mark - 私有方法
- (instancetype)init {
    if (self = [super init]) {
        _speed = 1.0;
    }
    return self;
}

#pragma mark - 懒加载

- (NSDate *)previousDate {
    if(_previousDate == nil) {
        _previousDate = [NSDate date];
    }
    return _previousDate;
}

- (JHSubTitleDisplayLink *)displayLink {
    if(_displayLink == nil) {
        _displayLink = [[JHSubTitleDisplayLink alloc] init];
        _displayLink.delegate = self;
    }
    return _displayLink;
}

@end
