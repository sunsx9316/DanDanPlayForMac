//
//  JHDanmakuCanvas.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuCanvas.h"

@implementation JHDanmakuCanvas

- (NSView *)hitTest:(NSPoint)aPoint{
    return nil;
}

- (void)layoutSubviews
{
    [self resizeSubviewsWithOldSize:[self frame].size];
    if (self.superview && !CGRectEqualToRect(self.frame, self.superview.bounds)) {
        self.frame = self.superview.bounds;
    }
}

- (void)didMoveToSuperview
{
    [self resizeSubviewsWithOldSize:[self frame].size];
}
@end
