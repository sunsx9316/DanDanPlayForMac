//
//  NSButton+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSButton+Tools.h"

@implementation NSButton (Tools)
- (void)setTitleColor:(NSColor *)color {
    if (!color) return;
    
    objc_setAssociatedObject(self, @"titleColor".UTF8String, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.attributedTitle == nil) return;
    
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    NSRange titleRange = NSMakeRange(0, colorTitle.length);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self setAttributedTitle:colorTitle];
}

- (NSColor *)titleColor {
    return objc_getAssociatedObject(self, @"titleColor".UTF8String);
}

- (void)setText:(NSString *)text {
    if (!text.length) {
        text = @"";
    }
    self.title = text;
    [self setTitleColor:self.titleColor];
}

- (NSString *)text {
    return self.title;
}

@end
