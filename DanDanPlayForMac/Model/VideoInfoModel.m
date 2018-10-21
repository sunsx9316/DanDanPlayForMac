//
//  VideoInfoModel.m
//  DanDanPlayer
//
//  Created by JimHuang on 16/1/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoInfoModel.h"

@implementation VideoInfoModel

@end

@implementation VideoInfoDataModel

@end

@implementation BiliBiliVideoInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"videos":[BiliBiliVideoInfoDataModel class]};
}
@end

@implementation BiliBiliVideoInfoDataModel

@end

@implementation AcfunVideoInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"videos":[AcfunVideoInfoDataModel class]};
}
@end

@implementation AcfunVideoInfoDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"danmaku":@"danmakuId"};
}
@end
