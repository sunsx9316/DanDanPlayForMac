//
//  BangumiModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BangumiModel.h"

@implementation BangumiModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"weekDay":@"DayOfWeek",@"bangumis":@"BangumiDetails"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"bangumis":[BangumiDataModel class]};
}
@end

@implementation BangumiDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"imageURL":@"ImageUrl",@"keyWord":@"Keyword",@"name":@"Name",@"groups":@"Groups"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"groups":[BangumiGroupModel class]};
}
@end

@implementation BangumiGroupModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"groupName":@"GroupName",@"searchURL":@"SearchUrl"};
}
@end