//
//  abstractDanmaku.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ParentDanmaku.h"

@implementation ParentDanmaku

- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(NSColor *)textColor text:(NSString *)text shadowStyle:(danmakuShadowStyle)shadowStyle font:(NSFont *)font{
    if (self = [super init]) {
        if (!font) font = [NSFont systemFontOfSize: fontSize];
        if (!text) text = @"";
        if (!textColor) textColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = font;
        dic[NSForegroundColorAttributeName] = textColor;
        switch (shadowStyle) {
            case danmakuShadowStyleGlow:
            {
                NSShadow *shadow = [self shadowWithTextColor:textColor];
                shadow.shadowBlurRadius = 3;
                dic[NSShadowAttributeName] = shadow;
            }
                break;
            case danmakuShadowStyleShadow:
            {
                dic[NSShadowAttributeName] = [self shadowWithTextColor:textColor];
            }
                break;
            case danmakuShadowStyleStroke:
            {
                dic[NSStrokeColorAttributeName] = [self shadowColorWithTextColor:textColor];
                dic[NSStrokeWidthAttributeName] = @-3;
            }
                break;
            default:
                break;
        }
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(DanmakuContainer *)container{
    return NO;
}

/**
 *  获取当前弹幕初始位置
 *
 *  @param arr            所有弹幕容器的数组
 *  @param channelCount   平分窗口的个数
 *  @param rect           窗口大小
 *  @param danmakuSize    弹幕尺寸
 *  @param timeDifference 弹幕出现时间与当前时间的时间差 回退功能需要使用
 *
 *  @return 弹幕初始位置
 */
- (CGPoint)originalPositonWithContainerArr:(NSArray <DanmakuContainer *>*)arr channelCount:(NSInteger)channelCount contentRect:(CGRect)rect danmakuSize:(CGSize)danmakuSize timeDifference:(NSTimeInterval)timeDifference{
    return CGPointZero;
}

- (NSString *)text{
    return _attributedString.string;
}
- (NSColor *)textColor{
    return [_attributedString attributesAtIndex:0 effectiveRange:nil][NSForegroundColorAttributeName];
}
- (NSAttributedString *)attributedString{
    return _attributedString;
}

#pragma mark - 私有方法
- (NSShadow *)shadowWithTextColor:(NSColor *)textColor{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, -1);
    shadow.shadowColor = [self shadowColorWithTextColor:textColor];
    return shadow;
}

- (NSColor *)shadowColorWithTextColor:(NSColor *)textColor{
    if (textColor.brightnessComponent > 0.5) {
        return [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
    }else{
        return [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
}
@end
