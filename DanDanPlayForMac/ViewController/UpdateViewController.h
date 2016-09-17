//
//  UpdateViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateViewController : BaseViewController
+ (instancetype)viewControllerWithVersion:(NSString *)version details:(NSString *)details hash:(NSString *)hash;
@end
