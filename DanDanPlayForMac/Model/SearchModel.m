//
//  AnimesModel.m
//  DanDanPlayer
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
    return @{@"title":@"Title"};
}
@end

@implementation BiliBiliSearchModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"result":[BiliBiliSearchDataModel class]};
}
@end

@implementation BiliBiliSearchDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"seasonId":@"season_id", @"desc":@"description", @"bangumi":@"is_bangumi"};
}
@end


@implementation AcFunSearchModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list":[AcFunSearchListModel class], @"special":[AcFunSearchSpecialModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"special":@"sp"};
}
@end


@implementation AcFunSearchListModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"desc":@"description"};
}
@end

@implementation AcFunSearchSpecialModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"desc":@"description"};
}
@end
