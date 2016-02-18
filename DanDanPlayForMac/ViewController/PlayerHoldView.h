//
//  playerHoldView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^filePickBlock)(NSArray *filePaths);
@interface PlayerHoldView : NSView
- (void)setUpBlock:(filePickBlock)block;
@end
