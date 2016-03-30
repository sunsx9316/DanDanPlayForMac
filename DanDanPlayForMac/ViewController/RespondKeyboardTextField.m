//
//  RespondKeyboardTextField.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RespondKeyboardTextField.h"
@implementation RespondKeyboardTextField
- (void)keyUp:(NSEvent *)theEvent{
    if (([theEvent keyCode] == 0x24 || [theEvent keyCode] == 0x4c) && self.respondBlock)
        self.respondBlock();
}
@end
