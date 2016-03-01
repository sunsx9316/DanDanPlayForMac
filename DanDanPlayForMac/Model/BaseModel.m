//
//  BaseModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
@implementation BaseModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}
@end
