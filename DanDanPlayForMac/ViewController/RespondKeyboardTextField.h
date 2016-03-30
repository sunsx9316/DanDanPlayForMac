//
//  RespondKeyboardTextField.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface RespondKeyboardTextField : NSTextField
@property (copy, nonatomic) void(^respondBlock)();
@end
