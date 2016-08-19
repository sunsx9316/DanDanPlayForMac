//
//  POPMasAnimation.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, POPMasAnimationType) {
    POPMasAnimationTypeLeft,
    POPMasAnimationTypeRight,
    POPMasAnimationTypeTop,
    POPMasAnimationTypeBottom
};

#import <pop/pop.h>
/**
 *  masonry约束的动画
 */
@interface POPMasAnimation : POPBasicAnimation
+ (instancetype)animationWithPropertyType:(POPMasAnimationType)type;
@end
