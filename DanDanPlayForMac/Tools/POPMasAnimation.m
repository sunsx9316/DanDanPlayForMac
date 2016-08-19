//
//  POPMasAnimation.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "POPMasAnimation.h"

@implementation POPMasAnimation
+ (instancetype)animationWithPropertyType:(POPMasAnimationType)type {
    POPMasAnimation *animation = [POPMasAnimation easeInEaseOutAnimation];
    animation.property = [self animatablePropertyWithType:type];
    return animation;
}

#pragma mark - 私有方法
+ (POPAnimatableProperty *)animatablePropertyWithType:(POPMasAnimationType)type {
    if (type == POPMasAnimationTypeLeft) {
        return [POPAnimatableProperty propertyWithName:@"mas_left_anima" initializer:^(POPMutableAnimatableProperty *prop) {
            [prop setWriteBlock:^(NSView *obj, const CGFloat *value) {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(value[0]);
                }];
            }];
        }];
    }
    else if (type == POPMasAnimationTypeRight) {
        return [POPAnimatableProperty propertyWithName:@"mas_right_anima" initializer:^(POPMutableAnimatableProperty *prop) {
            [prop setWriteBlock:^(NSView *obj, const CGFloat *value) {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(value[0]);
                }];
            }];
        }];
    }
    else if (type == POPMasAnimationTypeTop) {
        return [POPAnimatableProperty propertyWithName:@"mas_top_anima" initializer:^(POPMutableAnimatableProperty *prop) {
            [prop setWriteBlock:^(NSView *obj, const CGFloat *value) {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(value[0]);
                }];
            }];
        }];
    }
    else {
        return [POPAnimatableProperty propertyWithName:@"mas_bottom_anima" initializer:^(POPMutableAnimatableProperty *prop) {
            [prop setWriteBlock:^(NSView *obj, const CGFloat *value) {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(value[0]);
                }];
            }];
        }];
    }
}
@end
