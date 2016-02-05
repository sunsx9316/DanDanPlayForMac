//
//  ShiBanModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ShiBanModel.h"

@implementation ShiBanModel

@end


@implementation BiliBiliShiBanModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"episodes":[BiliBiliShiBanDataModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"detail":@"brief"};
}
@end

@implementation BiliBiliShiBanDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"title":@"index_title", @"danmuku":@"danmaku"};
}
@end