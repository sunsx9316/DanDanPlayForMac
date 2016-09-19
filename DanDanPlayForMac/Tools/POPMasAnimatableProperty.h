//
//  POPMasAnimatableProperty.h
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <pop/pop.h>

@interface POPMasAnimatableProperty : POPAnimatableProperty
typedef NS_ENUM(NSUInteger, POPMasAnimationType) {
    POPMasAnimationTypeLeft,
    POPMasAnimationTypeRight,
    POPMasAnimationTypeTop,
    POPMasAnimationTypeBottom
};

+ (POPAnimatableProperty *)animatablePropertyWithType:(POPMasAnimationType)type;
@end
