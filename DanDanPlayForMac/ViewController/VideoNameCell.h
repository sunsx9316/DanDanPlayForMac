//
//  VideoNameCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>

typedef void(^buttonCallBackBlock)();

@interface VideoNameCell : NSView
//- (void)setTitle:(NSString *)title iconHide:(BOOL)iconHide callBack:(buttonCallBackBlock)callBack;
- (void)setWithModel:(id<VideoModelProtocol>)model iconHide:(BOOL)iconHide callBack:(buttonCallBackBlock)callBack;
- (void)updateProgress:(float)progress;
@end
