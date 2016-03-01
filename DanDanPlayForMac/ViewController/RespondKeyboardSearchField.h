//
//  RespondKeyboardSearchField.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
typedef void(^respondBlock)();
#import <Cocoa/Cocoa.h>

@interface RespondKeyboardSearchField : NSSearchField
- (void)setWithBlock:(respondBlock)block;
@end
