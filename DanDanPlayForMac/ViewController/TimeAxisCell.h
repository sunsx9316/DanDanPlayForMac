//
//  TimeAxisCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^timeOffsetBlock)(NSInteger num);
@interface TimeAxisCell : NSView
- (void)setWithBlock:(timeOffsetBlock)block;
@end
