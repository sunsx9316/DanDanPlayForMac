//
//  JHDanmakuCanvas.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuCanvas.h"

@implementation JHDanmakuCanvas
- (JHView *)hitTest:(CGPoint)aPoint{
    return nil;
}

- (instancetype)init{
    if (self = [super init]) {
#if TARGET_OS_IPHONE
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
#else
        [self setWantsLayer:YES];
        self.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewHeightSizable | NSViewWidthSizable;
#endif
    }
    return self;
}


#if !TARGET_OS_IPHONE
- (void)resizeWithOldSuperviewSize:(NSSize)oldSize {
    [super resizeWithOldSuperviewSize:oldSize];
    if (self.resizeCallBackBlock) {
        self.resizeCallBackBlock(self.bounds);
    }
}
#endif
@end
