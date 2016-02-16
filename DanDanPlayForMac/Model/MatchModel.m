//
//  MatchModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MatchModel.h"

@implementation MatchModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"matches":[MatchDataModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"matches":@"Matches"};
}
@end

@implementation MatchDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"episodeId":@"EpisodeId", @"animeTitle":@"AnimeTitle", @"episodeTitle":@"EpisodeTitle"};
}
@end