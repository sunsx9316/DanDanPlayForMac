//
//  PlayerSubtitleViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayerSubtitleViewController : NSViewController
@property (copy, nonatomic) void(^timeOffsetCallBack)(NSInteger time);
@property (copy, nonatomic) void(^fontSizeChangeCallBack)(CGFloat value);
@property (copy, nonatomic) void(^chooseLoactionFileCallBack)();
@end
