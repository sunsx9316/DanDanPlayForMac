//
//  VideoNameCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
typedef void(^buttonCallBackBlock)();
#import <Cocoa/Cocoa.h>

@interface VideoNameCell : NSView
- (void)setTitle:(NSString *)title iconHide:(BOOL)iconHide callBack:(buttonCallBackBlock)callBack;
@end
