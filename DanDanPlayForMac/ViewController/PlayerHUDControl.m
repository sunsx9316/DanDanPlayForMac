//
//  PlayerHUDControl.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerHUDControl.h"

@implementation PlayerHUDControl

- (void)mouseDragged:(NSEvent *)theEvent{
    NSRect rect = self.frame;
    NSRect screenRect = self.superview.frame;
    rect.origin.x += theEvent.deltaX;
    rect.origin.y -= theEvent.deltaY;
    
    //防止出屏幕边界
    if (rect.origin.x < 0) {
        rect.origin.x = 0;
    }
    if (rect.origin.x + rect.size.width > screenRect.size.width) {
        rect.origin.x = screenRect.size.width - rect.size.width;
    }
    if (rect.origin.y < 0) {
        rect.origin.y = 0;
    }
    if (rect.origin.y + rect.size.height > screenRect.size.height) {
        rect.origin.y = screenRect.size.height - rect.size.height;
    }
    
    self.frame = rect;
}

@end
