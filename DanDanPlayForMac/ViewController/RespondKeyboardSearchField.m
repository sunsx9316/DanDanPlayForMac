//
//  RespondKeyboardSearchField.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RespondKeyboardSearchField.h"
@implementation RespondKeyboardSearchField
//点击回车或者return响应的事件
- (void)keyUp:(NSEvent *)theEvent{
    if (self.respondBlock && ([theEvent keyCode] == 0x24 || [theEvent keyCode] == 0x4c))
        self.respondBlock();
}

@end
