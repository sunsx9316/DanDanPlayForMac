//
//  VideoPlayURLModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoPlayURLModel.h"

@implementation VideoPlayURLModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"URLs":[VideoPlayURLDataModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"URLs":@"durl"};
}

@end

@implementation VideoPlayURLDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"URL":@"url", @"backURLs":@"backup_url"};
}
@end
