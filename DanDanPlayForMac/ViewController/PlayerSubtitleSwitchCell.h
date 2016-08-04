//
//  PlayerSubtitleSwitchCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 *  字幕开关cell
 */
@interface PlayerSubtitleSwitchCell : NSView
@property (copy, nonatomic) void(^touchButtonCallBack)(BOOL status);
@end
