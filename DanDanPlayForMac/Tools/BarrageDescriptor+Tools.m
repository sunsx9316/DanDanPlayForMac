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
#import "DanMuModel.h"

@implementation BarrageDescriptor (Tools)
+ (instancetype)descriptorWithModel:(DanMuDataModel *)model{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    if (model.mode == 1) {
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"speed"] = @(arc4random()%100 + 80);
    }else if(model.mode == 4 || model.mode == 5){
        descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);;
        descriptor.params[@"duration"] = @(3);
    }
    
    descriptor.params[@"text"] = model.message;
    descriptor.params[@"textColor"] = [NSColor colorWithRGB: (uint32_t)model.color];
    descriptor.params[@"direction"] = (model.mode == 1 || model.mode == 5) ? @(1) : @(2);
    descriptor.params[@"fontSize"] = @(model.fontSize);
    return descriptor;
}
@end
