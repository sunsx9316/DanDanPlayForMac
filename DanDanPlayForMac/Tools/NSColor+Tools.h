//
//  NSColor+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Tools)
+ (NSColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (NSColor *)colorWithRGB:(uint32_t)rgbValue;
@end
