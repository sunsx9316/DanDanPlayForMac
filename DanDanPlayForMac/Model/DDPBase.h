//
//  DDPBase.h
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//
#import <YYModel.h>

@interface DDPBase : NSObject <YYModel, NSCoding, NSCopying>

@property (assign, nonatomic) NSUInteger identity;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *desc;
@end
