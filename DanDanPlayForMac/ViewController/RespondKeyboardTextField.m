//
//  RespondKeyboardTextField.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RespondKeyboardTextField.h"
@interface RespondKeyboardTextField()
@property (copy, nonatomic) respondBlock block;
@end
@implementation RespondKeyboardTextField
- (void)keyUp:(NSEvent *)theEvent{
    if (([theEvent keyCode] == 0x24 || [theEvent keyCode] == 0x4c) && self.block)
        self.block();
}

- (void)setWithBlock:(respondBlock)block{
    self.block = block;
}
@end
