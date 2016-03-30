//
//  RespondKeyboardSearchField.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RespondKeyboardSearchField.h"
@implementation RespondKeyboardSearchField
- (void)keyUp:(NSEvent *)theEvent{
    if (self.respondBlock && ([theEvent keyCode] == 0x24 || [theEvent keyCode] == 0x4c))
        self.respondBlock();
}

@end
