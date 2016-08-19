//
//  NSView+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Tools)
- (CGPoint)center;
- (void)setCenter:(CGPoint)center;
- (void)setBackgroundColor:(NSColor *)color;
- (NSColor *)backgroundColor;
@end
