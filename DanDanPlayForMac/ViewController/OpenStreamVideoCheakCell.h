//
//  OpenStreamVideoCheakCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/10.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
typedef void(^clickCheakButtonCallBackBlock)(NSInteger state);

@interface OpenStreamVideoCheakCell : NSButton
- (void)setWithTitle:(NSString *)title callBackHandle:(clickCheakButtonCallBackBlock)callBackHandle;
@end
