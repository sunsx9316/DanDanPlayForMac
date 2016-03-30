//
//  PlayLastWatchVideoTimeView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
@interface PlayLastWatchVideoTimeView : NSView
@property (weak) IBOutlet NSTextField *videoTimeTextField;
//需要外部把上次的播放时间传进来
@property (assign, nonatomic) NSTimeInterval time;
@property (copy, nonatomic) void(^continusBlock)(NSTimeInterval time);
@property (copy, nonatomic) void(^closeViewBlock)();
- (void)show;
- (void)hide;
@end
