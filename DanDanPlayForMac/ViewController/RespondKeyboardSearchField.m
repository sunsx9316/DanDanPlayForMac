//
//  RespondKeyboardSearchField.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RespondKeyboardSearchField.h"
@interface RespondKeyboardSearchField()
@property (copy, nonatomic) respondBlock block;
@end
@implementation RespondKeyboardSearchField
- (void)keyUp:(NSEvent *)theEvent{
    if (([theEvent keyCode] == 0x24 || [theEvent keyCode] == 0x4c) && self.block)
    self.block();
}

- (void)setWithBlock:(respondBlock)block{
    self.block = block;
}

@end
