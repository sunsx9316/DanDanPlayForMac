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
//字幕标题
@property (copy, nonatomic) NSArray *subtitleTitles;
//字幕索引
@property (copy, nonatomic) NSArray *subtitleIndexs;
@property (copy, nonatomic) void(^touchSubtitleIndexCallBack)(int index);
@property (assign, nonatomic) int currentSubTitleIndex;
//点击开关
//@property (copy, nonatomic) void(^touchButtonCallBack)(BOOL status);
@end
