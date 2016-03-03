//
//  ColorMenuItem.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DanmakuColorMenuItem : NSMenuItem
- (NSUInteger)itemColor;
- (void)setItemColor:(NSColor *)color;
- (instancetype)initWithTitle:(NSString *)aString color:(NSColor *)color;
@end
