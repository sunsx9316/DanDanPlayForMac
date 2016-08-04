//
//  ScrollDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ParentDanmaku.h"
typedef NS_ENUM(NSUInteger, scrollDanmakuDirection) {
    scrollDanmakuDirectionR2L = 10,
    scrollDanmakuDirectionL2R,
    scrollDanmakuDirectionT2B,
    scrollDanmakuDirectionB2T,
};

@interface ScrollDanmaku : ParentDanmaku
/**
 *  初始化 阴影 字体
 *
 *  @param fontSize    文字大小(在font为空时有效)
 *  @param textColor   文字颜色(务必使用 colorWithRed:green:blue:alpha初始化)
 *  @param text        文本内容
 *  @param shadowStyle 阴影风格
 *  @param font        字体
 *  @param speed       弹幕速度
 *  @param direction   弹幕运动方向
 *
 *  @return self
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(JHColor *)textColor text:(NSString *)text shadowStyle:(danmakuShadowStyle)shadowStyle font:(JHFont *)font speed:(CGFloat)speed direction:(scrollDanmakuDirection)direction;
- (CGFloat)speed;
- (scrollDanmakuDirection)direction;
@end
