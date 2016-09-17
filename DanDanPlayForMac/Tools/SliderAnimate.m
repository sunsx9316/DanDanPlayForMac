//
//  SliderAnimate.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "SliderAnimate.h"
#import <POP.h>

@implementation SliderAnimate
- (void)animatePresentationOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController {
    if (self.presentationWillBeginCompletion) {
        self.presentationWillBeginCompletion();
    }
    
//    viewController.view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    CGRect fromViewFrame = fromViewController.view.frame;
    viewController.view.frame = [self toViewFrameWithFromViewFrame:fromViewFrame];
    
    fromViewController.view.wantsLayer = YES;
    [fromViewController.view addSubview:viewController.view];
    [fromViewController addChildViewController:viewController];
    
    POPBasicAnimation *anima = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anima.toValue = [NSValue valueWithRect:fromViewFrame];
    anima.duration = 0.4;
    [anima setCompletionBlock:^(POPAnimation *anima, BOOL isFinish) {
        if (self.presentationDidEndCompletion) {
            self.presentationDidEndCompletion();
        }
    }];
    [viewController.view pop_addAnimation:anima forKey:@"presentation_anima"];
}

- (void)animateDismissalOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController {
    if (self.dismissWillBeginCompletion) {
        self.dismissWillBeginCompletion();
    }
    
    fromViewController.view.wantsLayer = YES;
    CGRect dismissFrame = [self toViewFrameWithFromViewFrame:fromViewController.view.frame];
//    viewController.view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

    POPBasicAnimation *anima = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anima.toValue = [NSValue valueWithRect:dismissFrame];
    anima.duration = 0.4;
    [anima setCompletionBlock:^(POPAnimation *anima, BOOL isFinish) {
        [viewController removeFromParentViewController];
        [viewController.view removeFromSuperview];
        if (self.dismissDidEndCompletion) {
            self.dismissDidEndCompletion();
        }
    }];
    
    [viewController.view pop_addAnimation:anima forKey:@"presentation_anima"];
}

- (CGRect)toViewFrameWithFromViewFrame:(CGRect)fromViewFrame {
    switch (_direction) {
        case SliderAnimateDirectionB2T:
            fromViewFrame.origin.y = -fromViewFrame.size.height;
            return fromViewFrame;
        case SliderAnimateDirectionT2B:
            fromViewFrame.origin.y = fromViewFrame.size.height;
            return fromViewFrame;
        case SliderAnimateDirectionL2R:
            fromViewFrame.origin.x = -fromViewFrame.size.width;
            return fromViewFrame;
        case SliderAnimateDirectionR2L:
            fromViewFrame.origin.x = fromViewFrame.size.width;
            return fromViewFrame;
        default:
            break;
    }
}

@end
