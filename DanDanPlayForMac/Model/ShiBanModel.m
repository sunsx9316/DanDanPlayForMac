//
//  ShiBanModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ShiBanModel.h"

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
    return @{@"title":@"index_title", @"aid":@"av_id"};
}
@end

@implementation AcFunShiBanModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list":[AcFunShiBanDataModel class]};
}
@end


@implementation AcFunShiBanDataModel

@end