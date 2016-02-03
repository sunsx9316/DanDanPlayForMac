//
//  BarrageDescriptor+Tools.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BarrageDescriptor.h"
#import "BarrageHeader.h"
@class DanMuDataModel;
@interface BarrageDescriptor (Tools)
+ (instancetype)descriptorWithModel:(DanMuDataModel *)model;
@end
