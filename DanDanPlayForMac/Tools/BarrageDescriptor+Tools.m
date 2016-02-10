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
+ (instancetype)descriptorWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle edgeStyle:(DanMaKuSpiritEdgeStyle)edgeStyle fontSize:(CGFloat)fontSize{
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
    
    switch (edgeStyle) {
        case DanMaKuSpiritEdgeStyleShadow:
            descriptor.params[@"attributedText"] = [self shadowStringStyleWithText:text fontSize:fontSize textColor:[NSColor colorWithRGB: (uint32_t)color] descriptor: descriptor];
            break;
        case DanMaKuSpiritEdgeStyleGlow:
            descriptor.params[@"attributedText"] = [self glowStringStyleWithText:text fontSize:fontSize textColor:[NSColor colorWithRGB: (uint32_t)color] descriptor: descriptor];
            break;
        case DanMaKuSpiritEdgeStyleStroke:
            descriptor.params[@"attributedText"] = [self strokeStringStyleWithText:text fontSize:fontSize textColor:[NSColor colorWithRGB: (uint32_t)color] descriptor: descriptor];
            break;
        case DanMaKuSpiritEdgeStyleNone:
            descriptor.params[@"attributedText"] = [self noneStringStyleWithText:text fontSize:fontSize textColor:[NSColor colorWithRGB: (uint32_t)color] descriptor: descriptor];
            break;
        default:
            break;
    }
    
    return descriptor;
}

#pragma mark - 私有方法
+ (NSAttributedString *)shadowStringStyleWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(NSColor *)textColor descriptor:(BarrageDescriptor *)descriptor{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: text];
    NSShadow *shadow = [[NSShadow alloc] init];
    if (textColor.brightnessComponent > 0.5) {
        [shadow setShadowColor:[NSColor blackColor]];
    }else{
        [shadow setShadowColor:[NSColor whiteColor]];
    }
    
    [shadow setShadowOffset:NSMakeSize(1, -2)];
    [string addAttributes:@{NSShadowAttributeName: shadow, NSForegroundColorAttributeName: textColor, NSFontAttributeName: [NSFont systemFontOfSize: fontSize]} range: NSMakeRange(0, text.length)];
    return string;
}

+ (NSAttributedString *)glowStringStyleWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(NSColor *)textColor descriptor:(BarrageDescriptor *)descriptor{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: text];
    NSShadow *shadow = [[NSShadow alloc] init];
    if (textColor.brightnessComponent > 0.5) {
        [shadow setShadowColor:[NSColor blackColor]];
    }else{
        [shadow setShadowColor:[NSColor whiteColor]];
    }
    
    [shadow setShadowBlurRadius: 5];
    [string addAttributes:@{NSShadowAttributeName: shadow, NSForegroundColorAttributeName: textColor, NSFontAttributeName: [NSFont systemFontOfSize: fontSize]} range: NSMakeRange(0, text.length)];
    return string;
}

+ (NSAttributedString *)strokeStringStyleWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(NSColor *)textColor descriptor:(BarrageDescriptor *)descriptor{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: text];
    NSColor *strokeColor = nil;
    if (textColor.brightnessComponent > 0.5) {
        strokeColor = [NSColor blackColor];
    }else{
        strokeColor = [NSColor whiteColor];
    }
    
    [string addAttributes:@{NSStrokeWidthAttributeName: @(-2),NSStrokeColorAttributeName: strokeColor, NSForegroundColorAttributeName: textColor, NSFontAttributeName: [NSFont systemFontOfSize: fontSize]} range: NSMakeRange(0, text.length)];
    return string;
}

+ (NSAttributedString *)noneStringStyleWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(NSColor *)textColor descriptor:(BarrageDescriptor *)descriptor{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: text];
    [string addAttributes:@{NSForegroundColorAttributeName: textColor, NSFontAttributeName: [NSFont systemFontOfSize: fontSize]} range: NSMakeRange(0, text.length)];
    return string;
}
@end
