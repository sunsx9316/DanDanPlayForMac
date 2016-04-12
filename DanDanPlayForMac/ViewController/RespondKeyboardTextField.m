//
//  RespondKeyboardTextField.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RespondKeyboardTextField.h"
@implementation RespondKeyboardTextField
//点击回车或者return响应的事件
- (void)keyUp:(NSEvent *)theEvent{
    if (self.respondBlock && ([theEvent keyCode] == 0x24 || [theEvent keyCode] == 0x4c))
        self.respondBlock();
}
@end
