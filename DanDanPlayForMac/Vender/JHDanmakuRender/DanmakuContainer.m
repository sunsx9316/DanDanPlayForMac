//
//  DanmakuContainer.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanmakuContainer.h"

@implementation DanmakuContainer
{
    ParentDanmaku *_danmaku;
}
- (instancetype)initWithDanmaku:(ParentDanmaku *)danmaku{
    if (self = [super init]) {
#if !TARGET_OS_IPHONE
        self.editable = NO;
        self.drawsBackground = NO;
        self.bordered = NO;
#endif
        [self setWithDanmaku:danmaku];
    }
    return self;
}

- (void)setWithDanmaku:(ParentDanmaku *)danmaku{
    _danmaku = danmaku;
    self.textColor = danmaku.textColor;
    self.JHText = danmaku.text?danmaku.text:@"";
    self.JHAttributedText = danmaku.attributedString;
    [self sizeToFit];
}

- (BOOL)updatePositionWithTime:(NSTimeInterval)time{
    return [_danmaku updatePositonWithTime:time container:self];
}

- (ParentDanmaku *)danmaku{
    return _danmaku;
}

- (void)setOriginalPosition:(CGPoint)originalPosition{
    _originalPosition = originalPosition;
    CGRect rect = self.frame;
    rect.origin = originalPosition;
    self.frame = rect;
}

- (void)setGlobalAttributedDic:(NSDictionary *)globalAttributedDic{
    if (!self.JHAttributedText.length || !globalAttributedDic) return;
    _globalAttributedDic = globalAttributedDic;
    self.JHAttributedText = [[NSMutableAttributedString alloc] initWithString:self.JHAttributedText.string attributes:globalAttributedDic];
    [self sizeToFit];
}

- (void)setGlobalFont:(JHFont *)globalFont{
    if (!self.JHAttributedText.length || !globalFont) return;
    _globalFont = globalFont;
    NSMutableDictionary *dic = [[self.JHAttributedText attributesAtIndex:0 effectiveRange:nil] mutableCopy];
    dic[NSFontAttributeName] = globalFont;
    [self setGlobalAttributedDic:dic];
}

- (void)setGlobalShadowStyle:(NSNumber *)globalShadowStyle{
    if (!self.JHAttributedText.length || !globalShadowStyle) return;
    _globalShadowStyle = globalShadowStyle;
    danmakuShadowStyle shadowStyle = [globalShadowStyle unsignedIntegerValue];
    NSDictionary *tempDic = [self.JHAttributedText attributesAtIndex:0 effectiveRange:nil];
    JHColor *textColor = tempDic[NSForegroundColorAttributeName];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = tempDic[NSFontAttributeName];
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
    
    
    [self setGlobalAttributedDic:dic];
}

#pragma mark - 私有方法
- (NSShadow *)shadowWithTextColor:(JHColor *)textColor{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, -1);
    shadow.shadowColor = [self shadowColorWithTextColor:textColor];
    return shadow;
}
- (JHColor *)shadowColorWithTextColor:(JHColor *)textColor{
    if (JHColorBrightness(textColor) > 0.5) {
        return [JHColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return [JHColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
