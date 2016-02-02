//
//  NSColor+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSColor+Tools.h"

@implementation NSColor (Tools)
+ (NSColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha{
    return [NSColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}
+ (NSColor *)colorWithRGB:(uint32_t)rgbValue{
    return [NSColor colorWithRGB:rgbValue alpha: 1];
}
@end
