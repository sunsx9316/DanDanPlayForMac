//
//  NSButton+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSButton+Tools.h"

@implementation NSButton (Tools)
- (void)setTitleColor:(NSColor *)color{
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self setAttributedTitle:colorTitle];
}
@end
