//
//  HUDMessageView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HUDMessageView : NSView
@property (assign, nonatomic, getter=isReverse) BOOL reverse;
- (void)updateMessage:(NSString *)message;
- (void)show;
- (void)hide;
@end
