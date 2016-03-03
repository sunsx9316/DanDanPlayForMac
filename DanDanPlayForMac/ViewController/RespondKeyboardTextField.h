//
//  RespondKeyboardTextField.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
typedef void(^respondBlock)();
#import <Cocoa/Cocoa.h>

@interface RespondKeyboardTextField : NSTextField
- (void)setWithBlock:(respondBlock)block;
@end
