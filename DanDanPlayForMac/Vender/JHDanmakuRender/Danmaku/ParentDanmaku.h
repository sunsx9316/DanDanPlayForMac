//
//  abstractDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "BaseModel.h"

@class DanmakuContainer;
typedef NS_ENUM(NSUInteger, danmakuShadowStyle) {
    danmakuShadowStyleNone = 100,
    danmakuShadowStyleStroke,
    danmakuShadowStyleShadow,
    danmakuShadowStyleGlow,
};

@interface ParentDanmaku : BaseModel
@property (assign, nonatomic) NSTimeInterval appearTime;
@property (assign, nonatomic) NSTimeInterval disappearTime;
@property (strong, nonatomic) NSAttributedString *attributedString;
//弹幕是否被过滤
@property (assign, nonatomic, getter=isFilter) BOOL filter;
- (NSString *)text;
- (NSColor *)textColor;
- (CGPoint)originalPositonWithContainerArr:(NSArray <DanmakuContainer *>*)arr channelCount:(NSInteger)channelCount contentRect:(CGRect)rect danmakuSize:(CGSize)danmakuSize timeDifference:(NSTimeInterval)timeDifference;
/**
 *  更新位置
 *
 *  @param time      当前时间
 *  @param container 容器
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(DanmakuContainer *)container;
/**
 *  父类方法 不要使用
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(NSColor *)textColor text:(NSString *)text shadowStyle:(danmakuShadowStyle)shadowStyle font:(NSFont *)font;


@end
