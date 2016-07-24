//
//  PlayerSubtitleFontSizeCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayerSubtitleFontSizeCell : NSView
@property (copy, nonatomic) void(^fontSizeChangeCallBack)(CGFloat value);
@end
