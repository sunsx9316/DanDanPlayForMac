//
//  AnimesModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"animes":[SearchDataModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"animes":@"Animes"};
}
@end

@implementation SearchDataModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"episodes":[EpisodesModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"title":@"Title", @"episodes":@"Episodes", @"type":@"Type"};
}
@end

@implementation EpisodesModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"title":@"Title", @"identity":@"Id"};
}
@end