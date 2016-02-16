//
//  HideDanMuAndCloseCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
typedef void(^closeBlock)();
typedef void(^selectBlock)(NSInteger num, NSInteger status);

@interface HideDanMuAndCloseCell : NSView

- (void)setWithCloseBlock:(closeBlock)closeBlock selectBlock:(selectBlock)selectBlock;
@end
