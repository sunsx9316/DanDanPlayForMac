//
//  BackGroundImageView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^filePickBlock)(NSString *filePath);
@interface BackGroundImageView : NSImageView
- (void)setUpBlock:(filePickBlock)block;
@end
