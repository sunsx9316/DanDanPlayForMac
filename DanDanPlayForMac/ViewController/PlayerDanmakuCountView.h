//
//  PlayerDanmakuCountView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 *  显示弹幕数量的 view
 */
@interface PlayerDanmakuCountView : NSView
@property (assign, nonatomic) NSUInteger danmakuCount;
@property (copy, nonatomic) void(^touchCloseButtonCallBack)();
- (void)show;
- (void)dismiss;
@end
