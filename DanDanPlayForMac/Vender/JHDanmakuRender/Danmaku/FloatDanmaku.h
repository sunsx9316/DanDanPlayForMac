//
//  FloatDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import "ParentDanmaku.h"
typedef NS_ENUM(NSUInteger, floatDanmakuDirection) {
    floatDanmakuDirectionB2T = 100,
    floatDanmakuDirectionT2B
};
@interface FloatDanmaku : ParentDanmaku
/**
 *  初始化 阴影 字体
 *
 *  @param fontSize    文字大小
 *  @param textColor   文字颜色(务必使用 colorWithRed:green:blue:alpha初始化)
 *  @param text        文本
 *  @param shadowStyle 阴影类型
 *  @param font        字体
 *  @param during      弹幕持续时间
 *  @param direction   弹幕方向
 *
 *  @return self
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(JHColor *)textColor text:(NSString *)text shadowStyle:(danmakuShadowStyle)shadowStyle font:(JHFont *)font during:(CGFloat)during direction:(floatDanmakuDirection)direction;
- (CGFloat)during;
- (floatDanmakuDirection)direction;
@end
