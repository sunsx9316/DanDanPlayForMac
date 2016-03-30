//
//  UseFilterExpressionCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface UseFilterExpressionCell : NSView
@property (weak) IBOutlet NSButton *OKButton;
@property (copy, nonatomic) void(^clickBlock)(NSInteger state);
@end
