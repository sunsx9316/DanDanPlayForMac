//
//  JHSubTitleEngine.m
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubTitleEngine.h"
#import "JHSubTitleClock.h"
#import "JHSubTitleContainer.h"
#import "JHSubtitleParser.h"

@interface JHSubTitleEngine()<JHSubTitleClockDelegate>
@property (strong, nonatomic) JHSubTitleClock *clock;
/**
 *  当前未激活的字幕
 */
@property (strong, nonatomic) NSMutableArray <JHSubTitleContainer *>*inactiveContainer;
/**
 *  当前激活的字幕
 */
@property (strong, nonatomic) NSMutableArray <JHSubTitleContainer *>*activeContainer;
/**
 *  字幕缓存
 */
@property (strong, nonatomic) NSDictionary *subTitleCache;
@end

@implementation JHSubTitleEngine
{
    //当前毫秒
    NSString *_currentMillisecond;
    NSDictionary *_globalAttributedDic;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setSpeed:1.0];
        _currentMillisecond = @"-0.0";
    }
    return self;
}

- (void)setSpeed:(float)speed {
    self.clock.speed = speed;
}

- (void)start {
    [self.clock start];
}

- (void)stop {
    [self.clock stop];
}

- (void)pause {
    [self.clock pause];
}

- (void)addSubTitleWithPath:(NSString *)path {
    self.subTitleCache = [JHSubtitleParser subtitleDicWithPath:path];
}

- (void)addSubTitleWithMediaPath:(NSString *)path {
    NSArray *subtitleArr = [self subtitlePathsWithVideoPath:path];
    for (NSString *aPath in subtitleArr) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [self addSubTitleWithPath:aPath];
            break;
        }
    }
}

#if !TARGET_OS_IPHONE
//重设当前字幕初始位置
- (void)resetOriginalPosition:(CGRect)bounds {
    [self.activeContainer enumerateObjectsUsingBlock:^(JHSubTitleContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.subTitle originalPositonWithContainerArr:self.activeContainer contentRect:bounds subTitleSize:obj.bounds.size];
    }];
}
#endif

#pragma mark - JHSubTitleClockDelegate
- (void)sutitleClock:(JHSubTitleClock *)clock time:(NSTimeInterval)time {
    _currentTime = time;
    NSString *_formatTime = [NSString stringWithFormat:@"%.1f", _currentTime];
    //从字幕字典中拿到当前时间应该显示的字幕
    if (![_currentMillisecond isEqualToString:_formatTime]) {
        _currentMillisecond = _formatTime;
        NSArray *subtitles = [self.subTitleCache objectForKey:_currentMillisecond];
        for (JHSubtitle *subtitle in subtitles) {
            [self addSubtitle:subtitle];
        }
    }
    
    NSArray <JHSubTitleContainer *>*subtitles = self.activeContainer;
    for (NSInteger i = subtitles.count - 1; i >= 0; --i) {
        JHSubTitleContainer *container = subtitles[i];
        if (![container updatePositionWithTime:_currentTime]) {
            [self.activeContainer removeObjectAtIndex:i];
            [self.inactiveContainer addObject:container];
            [container removeFromSuperview];
            container.subTitle.disappearTime = _currentTime;
        }
    }

}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime < 0) return;
    _currentTime = currentTime;
    [self.clock setCurrentTime:currentTime];
}

- (void)setOffsetTime:(NSTimeInterval)offsetTime {
    [self.clock setOffsetTime:offsetTime];
}

- (NSTimeInterval)offsetTime {
    return self.clock.offsetTime;
}

- (void)setGlobalAttributedDic:(NSDictionary *)globalAttributedDic {
    if (![_globalAttributedDic isEqualToDictionary:globalAttributedDic]) {
        _globalAttributedDic = globalAttributedDic;
        NSArray *activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(JHSubTitleContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.globalAttributedDic = [self replaceGlobalAttributedDicToSubtitleAttDic:obj.globalAttributedDic];
        }];
        [self resetOriginalPosition:self.canvas.bounds];
    }
}

#pragma mark - 私有方法
- (void)addSubtitle:(JHSubtitle *)subtitle {
    JHSubTitleContainer *con = self.inactiveContainer.firstObject;
    //找缓存
    if (!con) {
        con = [[JHSubTitleContainer alloc] initWithSubTitle:subtitle];
    }
    else {
        [self.inactiveContainer removeObject:con];
        [con setWithSubTitle:subtitle];
    }
    
    con.globalAttributedDic = [self replaceGlobalAttributedDicToSubtitleAttDic:con.globalAttributedDic];
    
    con.originalPosition = [subtitle originalPositonWithContainerArr:self.activeContainer contentRect:self.canvas.bounds subTitleSize:con.bounds.size];

    [self.canvas addSubview: con];
    [self.activeContainer addObject:con];
}

/**
 *  从视频路径获取可能的字幕路径
 *
 *  @param path 视频路径
 *
 *  @return 字幕路径
 */
- (NSArray *)subtitlePathsWithVideoPath:(NSString *)path {
    NSString *deletingPathExtensionString = [path stringByDeletingPathExtension];
    NSArray *formatterArr = @[@"srt", @"ass"];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *formatter in formatterArr) {
        [arr addObject:[deletingPathExtensionString stringByAppendingPathExtension:formatter]];
    }
    return arr;
}

//按照全局字典属性替换容器字典属性
- (NSDictionary *)replaceGlobalAttributedDicToSubtitleAttDic:(NSDictionary *)subtitleAttDic {
    if (_globalAttributedDic) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:subtitleAttDic];
        __block BOOL isChange = NO;
        //遍历全局字典 替换掉对应的属性
        [_globalAttributedDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (tempDic[key]) {
                tempDic[key] = obj;
                isChange = YES;
            }
        }];
        
        if (isChange) return tempDic;
    }
    return nil;
}

#pragma mark - 懒加载

- (NSMutableArray <JHSubTitleContainer *> *)activeContainer {
	if(_activeContainer == nil) {
		_activeContainer = [[NSMutableArray <JHSubTitleContainer *> alloc] init];
	}
	return _activeContainer;
}

- (NSMutableArray <JHSubTitleContainer *> *)inactiveContainer {
	if(_inactiveContainer == nil) {
		_inactiveContainer = [[NSMutableArray <JHSubTitleContainer *> alloc] init];
	}
	return _inactiveContainer;
}

- (JHSubTitleClock *)clock {
	if(_clock == nil) {
        _clock = [[JHSubTitleClock alloc] init];
        _clock.delegate = self;
  	}
	return _clock;
}

- (NSDictionary *)subTitleCache {
	if(_subTitleCache == nil) {
		_subTitleCache = [[NSDictionary alloc] init];
	}
	return _subTitleCache;
}

- (JHSubTitleCanvas *)canvas {
    if(_canvas == nil) {
        _canvas = [[JHSubTitleCanvas alloc] init];
#if !TARGET_OS_IPHONE
        __weak typeof(self)weakSelf = self;
        [_canvas setResizeCallBackBlock:^(CGRect bounds) {
            if (weakSelf.resetSubtitlePositionWhenCanvasSizeChange) {
                [weakSelf resetOriginalPosition:bounds];
            }
        }];
#endif
    }
    return _canvas;
}

@end
