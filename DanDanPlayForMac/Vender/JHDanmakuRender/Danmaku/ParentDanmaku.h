//
//  abstractDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define JHColor UIColor
#define JHFont UIFont
#else
#import <Cocoa/Cocoa.h>
#define JHColor NSColor
#define JHFont NSFont
#endif
#import "BaseModel.h"

@class DanmakuContainer;
typedef NS_ENUM(NSUInteger, danmakuShadowStyle) {
    //啥也没有
    danmakuShadowStyleNone = 100,
    //描边
    danmakuShadowStyleStroke,
    //投影
    danmakuShadowStyleShadow,
    //模糊阴影
    danmakuShadowStyleGlow,
};

@interface ParentDanmaku : BaseModel
@property (assign, nonatomic) NSTimeInterval appearTime;
@property (assign, nonatomic) NSTimeInterval disappearTime;
@property (strong, nonatomic) NSAttributedString *attributedString;
//弹幕是否被过滤
@property (assign, nonatomic, getter=isFilter) BOOL filter;
- (NSString *)text;
- (JHColor *)textColor;
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
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(JHColor *)textColor text:(NSString *)text shadowStyle:(danmakuShadowStyle)shadowStyle font:(JHFont *)font;


@end
