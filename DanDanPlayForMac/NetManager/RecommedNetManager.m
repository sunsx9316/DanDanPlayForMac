//
//  RecommedNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommedNetManager.h"
#import <GDataXMLNode.h>
#import "FeaturedModel.h"
#import "BangumiModel.h"

@implementation RecommedNetManager
+ (id)recommedInfoWithCompletionHandler:(void(^)(id responseObj, NSError *error))complete{
    return [self GETWithPath:@"http://api.acplay.net:8089/api/v1/homepage?userId=0&token=0" parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        
        NSDictionary *featuredDic = [responseObj[@"InterestList"] firstObject];
        NSDictionary *bangumiOfDays = 1 < [responseObj[@"InterestList"] count] ? [responseObj[@"InterestList"] objectAtIndex:1] : nil;
        NSInteger weekDay = [self weekDay];
        NSDictionary *bangumiDic = weekDay < [bangumiOfDays[@"BangumiOfDays"] count] ?  [bangumiOfDays[@"BangumiOfDays"] objectAtIndex:weekDay] : nil;
        complete(@{@"featured":[FeaturedModel  yy_modelWithDictionary:featuredDic], @"bangumi":[BangumiModel yy_modelWithDictionary:bangumiDic]}, error);
    }];
}

#pragma mark - 私有方法
/**
 *  获取今天星期
 *
 *  @return 1~6对应星期一~六 0对应星期天
 */
+ (NSInteger)weekDay{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    return [comps weekday] - 1;
}
@end
