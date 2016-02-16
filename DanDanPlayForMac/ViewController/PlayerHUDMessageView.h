//
//  PlayerHUDMessageView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 *  另一种风格的匹配提示视图
 */
@interface PlayerHUDMessageView : NSView
@property (strong, nonatomic) NSTextField *text;
- (void)showHUD;
- (void)hideHUD;
@end
