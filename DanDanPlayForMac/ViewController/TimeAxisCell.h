//
//  TimeAxisCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface TimeAxisCell : NSView
@property (copy, nonatomic) void(^timeOffsetBlock)(NSInteger value);
@end
