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
    self.status = PlayerControlViewStatusActive;
}

- (void)mouseExited:(NSEvent *)theEvent{
    self.status = PlayerControlViewStatusHalfActive;
}

- (void)setLeftExpansion:(BOOL)leftExpansion {
    _leftExpansion = leftExpansion;
    if (self.leftCallBackBlock) {
        self.leftCallBackBlock(leftExpansion);
    }
}

- (void)setRightExpansion:(BOOL)rightExpansion {
    _rightExpansion = rightExpansion;
    if (self.rightCallBackBlock) {
        self.rightCallBackBlock(rightExpansion);
    }
}

- (void)setStatus:(PlayerControlViewStatus)status {
    _status = status;
    if (self.statusCallBackBlock) {
        self.statusCallBackBlock(status);
    }
}

- (void)dealloc{
    [self removeTrackingArea:self.trackingArea];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTrackingArea:self.trackingArea];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = RGBColor(27, 29, 37).CGColor;
}

#pragma mark - 懒加载
- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

@end
