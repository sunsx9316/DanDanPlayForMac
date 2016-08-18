//
//  JHDanmakuEngine.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine.h"
#import "JHDanmakuClock.h"
#import "DanmakuContainer.h"
#import "ScrollDanmaku.h"
#import "FloatDanmaku.h"
@interface JHDanmakuEngine()<JHDanmakuClockDelegate>
@property (strong, nonatomic) JHDanmakuClock *clock;
/**
 *  当前未激活的弹幕
 */
@property (strong, nonatomic) NSMutableArray <DanmakuContainer *>*inactiveContainer;
/**
 *  当前激活的弹幕
 */
@property (strong, nonatomic) NSMutableArray <DanmakuContainer *>*activeContainer;
/**
 *  弹幕缓存 开启回退功能时启用
 */
@property (strong, nonatomic) NSDictionary *danmakusCache;

@property (assign, nonatomic) NSInteger intTime;
//用于记录当前时间的整数值
@end

@implementation JHDanmakuEngine
{
    NSInteger _intTime;
    float _extraSpeed;
}
- (instancetype)init {
    if (self = [super init]) {
        _intTime = -1;
        [self setSpeed: 1.0];
    }
    return self;
}

- (void)start {
    [self.clock start];
}

- (void)stop {
    [self.clock stop];
    [self.activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.activeContainer removeAllObjects];
}

- (void)pause {
    [self.clock pause];
}

- (void)sendDanmaku:(ParentDanmaku *)danmaku {
    //被过滤不显示
    if (danmaku.isFilter || ([self.globalFilterDanmaku containsObject:@([(ScrollDanmaku *)danmaku direction])]) || ([self.globalFilterDanmaku containsObject:@([(FloatDanmaku *)danmaku direction])])) return;
    
    //没有开启回退功能 将当前时间作为弹幕的发射时间
    if (!self.turnonBackFunction) danmaku.appearTime = _currentTime;
    danmaku.extraSpeed = _extraSpeed;
    
    DanmakuContainer *con = self.inactiveContainer.firstObject;
    if (!con) {
        con = [[DanmakuContainer alloc] initWithDanmaku:danmaku];
    }
    else {
        [self.inactiveContainer removeObject:con];
        [con setWithDanmaku:danmaku];
    }
    
    if (_globalAttributedDic) con.globalAttributedDic = _globalAttributedDic;
    if (_globalFont) con.globalFont = _globalFont;
    if (_globalShadowStyle) con.globalShadowStyle = _globalShadowStyle;
    
    con.originalPosition = [danmaku originalPositonWithContainerArr:self.activeContainer channelCount:self.channelCount contentRect:self.canvas.bounds danmakuSize:con.bounds.size timeDifference:danmaku.appearTime - _currentTime];
    [self.canvas addSubview: con];
    [self.activeContainer addObject:con];
}

- (void)sendAllDanmakus:(NSArray <ParentDanmaku *>*)danmakus {
    NSMutableDictionary <NSNumber *,NSMutableArray <ParentDanmaku *>*>*dic = [NSMutableDictionary dictionary];
    for (ParentDanmaku *danmaku in danmakus) {
        NSInteger time = danmaku.appearTime;
        if (![dic objectForKey:@(time)]) {
            [dic setObject:[NSMutableArray array] forKey:@(time)];
        }
        [[dic objectForKey:@(time)] addObject:danmaku];
    }
    self.danmakusCache = dic;
}

- (void)sendAllDanmakusDic:(NSDictionary <NSNumber *,NSArray <ParentDanmaku *>*>*)danmakus {
    self.currentTime = 0;
    self.danmakusCache = danmakus;
}

- (void)setOffsetTime:(NSTimeInterval)offsetTime {
    [self.clock setOffsetTime:offsetTime];
    [self reloadPreDanmaku];
}

- (NSTimeInterval)offsetTime {
    return self.clock.offsetTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime < 0) return;
    _currentTime = currentTime;
    [self.clock setCurrentTime:currentTime];
    [self reloadPreDanmaku];
}

- (void)setChannelCount:(NSInteger)channelCount {
    if (channelCount >= 0) {
        _channelCount = channelCount;
        [self setCurrentTime:_currentTime];
    }
}

- (void)setSpeed:(float)speed {
    _extraSpeed = speed > 0 ? speed : 0.1;
    [self.activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.danmaku.extraSpeed = _extraSpeed;
    }];
}

- (void)setGlobalAttributedDic:(NSDictionary *)globalAttributedDic {
    if (![_globalAttributedDic isEqualToDictionary:globalAttributedDic]) {
        _globalAttributedDic = globalAttributedDic;
        NSArray *activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.globalAttributedDic = globalAttributedDic;
        }];
    }
}

- (void)setGlobalFont:(JHFont *)globalFont {
    if (![_globalFont isEqual: globalFont]){
        _globalFont = globalFont;
        NSArray *activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.globalFont = globalFont;
        }];
    }
}

- (void)setGlobalShadowStyle:(NSNumber *)globalShadowStyle {
    if (![globalShadowStyle isEqual: _globalShadowStyle]) {
        _globalShadowStyle = globalShadowStyle;
        NSArray *activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.globalShadowStyle = globalShadowStyle;
        }];
    }
}

#pragma mark - JHDanmakuClockDelegate

- (void)danmakuClock:(JHDanmakuClock *)clock time:(NSTimeInterval)time {
    _currentTime = time;
    //每秒获取一次弹幕 开启回退功能时启用
    if (self.turnonBackFunction && (NSInteger)_currentTime - _intTime) {
        _intTime = _currentTime;
        NSArray *danmakus = [self.danmakusCache objectForKey:@((NSInteger)_currentTime)];
        for (ParentDanmaku *danmaku in danmakus) {
            [self sendDanmaku:danmaku];
        }
    }
    
    NSArray <DanmakuContainer *>*danmakus = self.activeContainer;
    for (NSInteger i = danmakus.count - 1; i >= 0; --i) {
        DanmakuContainer *container = danmakus[i];
        if (![container updatePositionWithTime:_currentTime]) {
            [self.activeContainer removeObjectAtIndex:i];
            [self.inactiveContainer addObject:container];
            [container removeFromSuperview];
            container.danmaku.disappearTime = _currentTime;
        }
    }
}

#pragma mark - 私有方法
//预加载前5秒的弹幕
- (void)reloadPreDanmaku {
    if (self.turnonBackFunction) {
        [self.activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.activeContainer removeAllObjects];
        for (NSInteger i = 1; i <= 5; ++i) {
            NSInteger time = _currentTime - i;
            NSArray *danmakus = [self.danmakusCache objectForKey:@(time)];
            for (ParentDanmaku *danmaku in danmakus) {
                [self sendDanmaku:danmaku];
            }
        }
    }
}

//重设当前弹幕初始位置
- (void)resetOriginalPosition:(CGRect)bounds {
    [self.activeContainer enumerateObjectsUsingBlock:^(DanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.originalPosition = [obj.danmaku originalPositonWithContainerArr:self.activeContainer channelCount:self.channelCount contentRect:bounds danmakuSize:obj.bounds.size timeDifference:_currentTime - obj.danmaku.appearTime];
    }];
}

#pragma mark - 懒加载
- (JHDanmakuClock *)clock {
    if(_clock == nil) {
        _clock = [[JHDanmakuClock alloc] init];
        _clock.delegate = self;
    }
    return _clock;
}


- (NSMutableArray <DanmakuContainer *> *)inactiveContainer {
    if(_inactiveContainer == nil) {
        _inactiveContainer = [NSMutableArray array];
    }
    return _inactiveContainer;
}

- (NSMutableArray <DanmakuContainer *> *)activeContainer {
    if(_activeContainer == nil) {
        _activeContainer = [[NSMutableArray <DanmakuContainer *> alloc] init];
    }
    return _activeContainer;
}

- (NSDictionary *)danmakusCache {
    if(_danmakusCache == nil) {
        _danmakusCache = [[NSDictionary alloc] init];
    }
    return _danmakusCache;
}

- (JHDanmakuCanvas *)canvas {
    if(_canvas == nil) {
        _canvas = [[JHDanmakuCanvas alloc] init];
        __weak typeof(self)weakSelf = self;
        [_canvas setResizeCallBackBlock:^(CGRect bounds) {
            [weakSelf resetOriginalPosition:bounds];
        }];
    }
    return _canvas;
}

- (NSMutableSet *)globalFilterDanmaku {
    if(_globalFilterDanmaku == nil) {
        _globalFilterDanmaku = [[NSMutableSet alloc] init];
    }
    return _globalFilterDanmaku;
}

@end
