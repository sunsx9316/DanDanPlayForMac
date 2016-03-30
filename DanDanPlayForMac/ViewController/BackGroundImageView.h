//
//  BackGroundImageView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface BackGroundImageView : NSImageView
@property (copy, nonatomic) void(^filePickBlock)(NSArray *filePaths);
@end
