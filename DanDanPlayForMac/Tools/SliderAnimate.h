//
//  SliderAnimate.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SliderAnimateDirection) {
    SliderAnimateDirectionL2R,
    SliderAnimateDirectionR2L,
    SliderAnimateDirectionT2B,
    SliderAnimateDirectionB2T
};

@interface SliderAnimate : NSObject<NSViewControllerPresentationAnimator>
@property (copy, nonatomic) void(^presentationWillBeginCompletion)(void);
@property (copy, nonatomic) void(^presentationDidEndCompletion)(void);
@property (copy, nonatomic) void(^dismissDidEndCompletion)(void);
@property (copy, nonatomic) void(^dismissWillBeginCompletion)(void);
@property (assign, nonatomic) SliderAnimateDirection direction;
@end
