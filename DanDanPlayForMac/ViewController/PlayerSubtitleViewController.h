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
@property (copy, nonatomic) void(^chooseLoactionFileCallBack)();
//@property (copy, nonatomic) void(^touchSwitchButtonCallBack)(BOOL status);
@property (copy, nonatomic) void(^touchSubtitleIndexCallBack)(int index);

//字幕标题
@property (copy, nonatomic) NSArray *subtitleTitles;
//字幕索引
@property (copy, nonatomic) NSArray *subtitleIndexs;
@property (assign, nonatomic) int currentSubtitleIndex;
@end
