//
//  PlayLastWatchVideoTimeView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
typedef void(^continusBlock)(NSTimeInterval time);
typedef void(^closeViewBlock)();

@interface PlayLastWatchVideoTimeView : NSView
@property (weak) IBOutlet NSTextField *videoTimeTextField;
//需要外部把上次的播放时间传进来
@property (assign, nonatomic) NSTimeInterval time;

- (void)setContinusBlock:(continusBlock)block;
- (void)setCloseViewBlock:(closeViewBlock)block;
- (void)show;
- (void)hide;
@end
