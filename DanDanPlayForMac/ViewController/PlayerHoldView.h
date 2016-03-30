//
//  playerHoldView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface PlayerHoldView : NSView
@property (copy, nonatomic) void(^filePickBlock)(NSArray *filePaths);
@end
