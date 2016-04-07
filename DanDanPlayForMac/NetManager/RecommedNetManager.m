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
        BangumiModel *bangumiModel = [[BangumiModel alloc] init];
        FeaturedModel *featuredModel = [[FeaturedModel alloc] init];
        NSArray *interestListArr = responseObj[@"InterestList"];
        if (interestListArr.count > 0) {
            featuredModel = [FeaturedModel yy_modelWithDictionary:interestListArr[1]];
        }
        
        if (interestListArr.count > 1) {
            NSInteger weekDay = [self weekDay];
            NSArray *bangumiOfDaysArr = interestListArr[2][@"BangumiOfDays"];
            if (bangumiOfDaysArr.count > weekDay) {
                bangumiModel = [BangumiModel yy_modelWithDictionary:bangumiOfDaysArr[weekDay]];
            }
        }
        complete(@{@"featured":featuredModel, @"bangumi":bangumiModel}, error);
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
