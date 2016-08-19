//
//  PlayerSubtitleTimeOffsetCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/21.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayerSubtitleTimeOffsetCell : NSView
@property (copy, nonatomic) void(^timeOffsetCallBack)(NSInteger time);
@end
