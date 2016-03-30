//
//  RespondKeyboardSearchField.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
typedef void(^respondBlock)();

@interface RespondKeyboardSearchField : NSSearchField
@property (copy, nonatomic) void(^respondBlock)();
@end
