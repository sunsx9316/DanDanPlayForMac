//
//  PlayerHUDMessageView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 *  提示面板 比如音量
 */
@interface HUDMessageView : NSView
@property (copy, nonatomic) NSString *text;
- (void)showHUD;
- (void)showHUDWithAnimateTime:(NSTimeInterval)time;
- (void)hideHUD;
@end
