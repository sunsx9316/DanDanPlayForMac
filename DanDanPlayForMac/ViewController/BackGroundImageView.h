//
//  BackGroundImageView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^filePickBlock)(NSArray *filePaths);
@interface BackGroundImageView : NSImageView
- (void)setupBlock:(filePickBlock)block;
@end
