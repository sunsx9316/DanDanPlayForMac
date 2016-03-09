//
//  UpdateViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UpdateViewController : NSViewController
- (instancetype)initWithVersion:(NSString *)version details:(NSString *)details;
@end
