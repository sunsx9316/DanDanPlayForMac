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
@property (strong, nonatomic) timeBlock block;
@end

@implementation JHDanmakuClock
{
    CGFloat _originalSpeed;
    NSTimeInterval _currentTime;
    NSTimeInterval _offsetTime;
}

+ (instancetype)clockWithHandler:(timeBlock)block{
    return [[JHDanmakuClock alloc] initWithHandler:block];
}

- (void)start{
    _speed = _originalSpeed;
    [self.displayLink start];
}

- (void)stop{
    _previousDate = nil;
    _currentTime = 0.0;
    [self.displayLink stop];
}

- (void)pause{
    _speed = 0.0;
}

- (void)setSpeed:(CGFloat)speed{
    //非暂停状态下
    if (_speed > 0) {
        _speed = speed;
    }
    if (speed >= 0) {
        _originalSpeed = speed;
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime{
    if (currentTime >= 0) {
        _currentTime = currentTime;
    }
}

- (void)setOffsetTime:(NSTimeInterval)offsetTime{
    _offsetTime = offsetTime;
}

- (void)updateTime{
    NSDate *date = [NSDate date];
    _currentTime += [date timeIntervalSinceDate:self.previousDate] * self.speed;
    self.previousDate = date;
    
    if (self.block) {
        self.block(_currentTime + _offsetTime);
    }
}

- (void)displayLink:(JHDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp{
    [self updateTime];
}

#pragma mark - 私有方法
- (instancetype)initWithHandler:(timeBlock)block{
    if (self = [super init]) {
        self.block = block;
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

- (JHDisplayLink *)displayLink {
	if(_displayLink == nil) {
		_displayLink = [[JHDisplayLink alloc] init];
        _displayLink.delegate = self;
	}
	return _displayLink;
}

@end
