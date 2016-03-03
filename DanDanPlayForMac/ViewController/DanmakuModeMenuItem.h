//
//  DanmakuModeMenuItem.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DanmakuModeMenuItem : NSMenuItem
- (NSInteger)mode;
- (instancetype)initWithMode:(NSInteger)mode title:(NSString *)title;
@end
