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
    //默认颜色
    [self setTitleColor: [NSColor colorWithRed:80 / 255.0 green:163 / 255.0 blue:247 / 255.0 alpha:1]];
}


@end
