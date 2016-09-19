//
//  UpdateViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
@class VersionModel;
@interface UpdateViewController : BaseViewController
+ (instancetype)viewControllerWithModel:(VersionModel *)model;
@end
