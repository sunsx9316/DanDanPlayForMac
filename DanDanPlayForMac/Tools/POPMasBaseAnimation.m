//
//  POPMasAnimation.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "POPMasBaseAnimation.h"

@implementation POPMasBaseAnimation
+ (instancetype)animationWithPropertyType:(POPMasAnimationType)type {
    POPMasBaseAnimation *animation = [POPMasBaseAnimation easeInEaseOutAnimation];
    animation.property = [POPMasAnimatableProperty animatablePropertyWithType:type];
    return animation;
}
@end
