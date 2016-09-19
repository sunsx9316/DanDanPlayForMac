//
//  POPMasSpringAnimation.m
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "POPMasSpringAnimation.h"

@implementation POPMasSpringAnimation
+ (instancetype)animationWithPropertyType:(POPMasAnimationType)type {
    POPMasSpringAnimation *animation = [POPMasSpringAnimation animation];
    animation.property = [POPMasAnimatableProperty animatablePropertyWithType:type];
    return animation;
}
@end
