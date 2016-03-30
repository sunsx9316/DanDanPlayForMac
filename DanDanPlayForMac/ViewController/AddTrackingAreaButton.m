//
//  AddTrackingAreaButton.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AddTrackingAreaButton.h"
@interface AddTrackingAreaButton()
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end

@implementation AddTrackingAreaButton

- (void)mouseEntered:(NSEvent *)theEvent{
    if (self.mouseEnteredCallBackBlock) {
        self.mouseEnteredCallBackBlock();
    }
}

- (void)mouseExited:(NSEvent *)theEvent{
    if (self.mouseExitedCallBackBlock) {
        self.mouseExitedCallBackBlock();
    }
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

- (void)dealloc{
    [self removeTrackingArea:self.trackingArea];
}

- (instancetype)init{
    if (self = [super init]) {
        [self addTrackingArea:self.trackingArea];
    }
    return self;
}

@end
