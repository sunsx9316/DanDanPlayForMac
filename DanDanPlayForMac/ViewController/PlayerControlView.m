//
//  PlayerControlView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerControlView.h"
#import "DanmakuModeMenuItem.h"
#import "DanmakuColorMenuItem.h"
#import "RespondKeyboardTextField.h"
#import "AddTrackingAreaButton.h"
#import "PlayerSlideView.h"

@interface PlayerControlView()
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end

@implementation PlayerControlView

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

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTrackingArea:self.trackingArea];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [NSColor colorWithRed:27 / 255.0 green:29 / 255.0 blue:37 / 255.0 alpha:1].CGColor;
}

@end
