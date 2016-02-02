//
//  ColorButton.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/29.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSColor *color = [NSColor blueColor];
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self setAttributedTitle:colorTitle];
}

@end
