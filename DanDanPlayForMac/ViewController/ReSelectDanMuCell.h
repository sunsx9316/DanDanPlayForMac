//
//  ReSelectDanMuCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^reselectBlock)();

@interface ReSelectDanMuCell : NSView
- (void)setWithBlock:(reselectBlock)block;
@end
