//
//  OnlyButtonCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^buttonDownBlock)();

@interface OnlyButtonCell : NSView
@property (strong, nonatomic) NSButton *button;
- (void)setWithBlock:(buttonDownBlock)block;
@end
