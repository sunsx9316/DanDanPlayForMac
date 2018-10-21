//
//  DDPBase.m
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DDPBase.h"
@implementation DDPBase
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)mutableCopy {
    return [self yy_modelCopy];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}
@end
