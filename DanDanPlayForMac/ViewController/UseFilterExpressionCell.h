//
//  UseFilterExpressionCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
typedef void(^clickBlock)(NSInteger state);
#import <Cocoa/Cocoa.h>

@interface UseFilterExpressionCell : NSView
@property (weak) IBOutlet NSButton *OKButton;
- (void)setWithBlock:(clickBlock)block;
@end
