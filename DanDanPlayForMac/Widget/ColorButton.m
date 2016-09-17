//
//  ColorButton.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/29.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ColorButton.h"


@implementation ColorButton

- (void)awakeFromNib {
    [super awakeFromNib];
    //默认颜色
    [self setTitleColor: RGBColor(48, 131, 251)];
}


@end
