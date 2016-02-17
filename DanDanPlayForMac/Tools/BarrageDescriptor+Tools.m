//
//  BarrageDescriptor+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BarrageDescriptor+Tools.h"
#import "BarrageHeader.h"
#import "NSColor+Tools.h"
#import "DanMuModel.h"

@implementation BarrageDescriptor (Tools)
+ (instancetype)descriptorWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle edgeStyle:(DanMaKuSpiritEdgeStyle)edgeStyle fontSize:(CGFloat)fontSize font:(NSFont *)font{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    if (spiritStyle == 1) {
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"speed"] = @(arc4random()%100 + 50);
    }else if(spiritStyle == 4 || spiritStyle == 5){
        descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);;
        descriptor.params[@"duration"] = @(3);
    }
    descriptor.params[@"text"] = text;
    descriptor.params[@"direction"] = (spiritStyle == 1 || spiritStyle == 5) ? @(1) : @(2);
    descriptor.params[@"fontSize"] = @(fontSize);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
    
    switch (edgeStyle) {
        case DanMaKuSpiritEdgeStyleShadow:
            [self shadowStringStyleWithAttributedString:str textColor:[NSColor colorWithRGB: (uint32_t)color]];
            break;
        case DanMaKuSpiritEdgeStyleGlow:
            [self glowStringStyleWithAttributedString:str textColor:[NSColor colorWithRGB: (uint32_t)color]];
            break;
        case DanMaKuSpiritEdgeStyleStroke:
            [self strokeStringStyleWithAttributedString:str textColor:[NSColor colorWithRGB: (uint32_t)color]];
            break;
        case DanMaKuSpiritEdgeStyleNone:
            [self noneStringStyleWithAttributedString:str textColor:[NSColor colorWithRGB: (uint32_t)color]];
            break;
        default:
            break;
    }
    descriptor.params[@"attributedText"] = str;
    
    return descriptor;
}

#pragma mark - 私有方法
+ (void)shadowStringStyleWithAttributedString:(NSMutableAttributedString *)string textColor:(NSColor *)textColor{
    
    NSShadow *shadow = [[NSShadow alloc] init];
    if (textColor.brightnessComponent > 0.5) {
        [shadow setShadowColor:[NSColor blackColor]];
    }else{
        [shadow setShadowColor:[NSColor whiteColor]];
    }
    
    [shadow setShadowOffset:NSMakeSize(1, -2)];
    [string addAttributes:@{NSShadowAttributeName: shadow, NSForegroundColorAttributeName: textColor} range: NSMakeRange(0, string.length)];
}

+ (void)glowStringStyleWithAttributedString:(NSMutableAttributedString *)string textColor:(NSColor *)textColor{

    NSShadow *shadow = [[NSShadow alloc] init];
    if (textColor.brightnessComponent > 0.5) {
        [shadow setShadowColor:[NSColor blackColor]];
    }else{
        [shadow setShadowColor:[NSColor whiteColor]];
    }
    
    [shadow setShadowBlurRadius: 5];
    [string addAttributes:@{NSShadowAttributeName: shadow, NSForegroundColorAttributeName: textColor} range: NSMakeRange(0, string.length)];
}

+ (void)strokeStringStyleWithAttributedString:(NSMutableAttributedString *)string textColor:(NSColor *)textColor{
    NSColor *strokeColor = nil;
    if (textColor.brightnessComponent > 0.5) {
        strokeColor = [NSColor blackColor];
    }else{
        strokeColor = [NSColor whiteColor];
    }
    
    [string addAttributes:@{NSStrokeWidthAttributeName: @(-2),NSStrokeColorAttributeName: strokeColor, NSForegroundColorAttributeName: textColor} range: NSMakeRange(0, string.length)];
}

+ (void)noneStringStyleWithAttributedString:(NSMutableAttributedString *)string textColor:(NSColor *)textColor{
    [string addAttributes:@{NSForegroundColorAttributeName: textColor} range: NSMakeRange(0, string.length)];
}
@end
