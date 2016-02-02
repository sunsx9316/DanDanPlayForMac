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

@implementation BarrageDescriptor (Tools)
+ (instancetype)descriptorWithText:(NSString*)text color:(NSInteger)color style:(NSInteger)style fontSize:(NSInteger)fontSize{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    if (style == 1) {
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"speed"] = @(arc4random()%100 + 50);
    }else if(style == 4 || style == 5){
        descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);;
        descriptor.params[@"duration"] = @(3);
    }
    
    descriptor.params[@"text"] = text;
    descriptor.params[@"textColor"] = [NSColor colorWithRGB: (uint32_t)color];
    descriptor.params[@"direction"] = (style == 1 || style == 5) ? @(1) : @(2);
    descriptor.params[@"fontSize"] = @(fontSize);
    return descriptor;
}
@end
