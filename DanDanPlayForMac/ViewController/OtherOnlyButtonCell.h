//
//  PlayHistoryCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/25.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OtherOnlyButtonCell : NSView
- (void)setWithTitle:(NSString *)title info:(NSString *)info buttonText:(NSString *)buttonText;
@property (copy, nonatomic) void(^clickButtonCallBackBlock)();
@end
