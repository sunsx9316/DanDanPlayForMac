//
//  POPMasAnimation.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "POPMasAnimatableProperty.h"
/**
 *  masonry约束的动画
 */
@interface POPMasBaseAnimation : POPBasicAnimation
+ (instancetype)animationWithPropertyType:(POPMasAnimationType)type;
@end
