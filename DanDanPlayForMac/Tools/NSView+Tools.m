//
//  NSView+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSView+Tools.h"

@implementation NSView (Tools)
- (CGPoint)center {
    CGRect frame = self.frame;
    return CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
}
- (void)setCenter:(CGPoint)center {
    CGRect frame = self.frame;
    frame.origin.x = center.x - frame.size.width / 2;
    frame.origin.y = center.y - frame.size.height / 2;
    self.frame = frame;
}

- (void)setBackgroundColor:(NSColor *)color {
    self.wantsLayer = YES;
    self.layer.backgroundColor = color.CGColor;
}

- (NSColor *)backgroundColor {
    if (self.layer.backgroundColor) {
        return [NSColor colorWithCGColor:self.layer.backgroundColor];
    }
    return nil;
}
@end
