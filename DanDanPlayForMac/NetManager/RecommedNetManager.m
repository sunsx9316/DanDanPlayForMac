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
+ (NSURLSessionDataTask *)recommedInfoWithCompletionHandler:(void(^)(FeaturedModel *featuredModel, NSArray *bangumis, DanDanPlayErrorModel *error))complete {
    return [self GETWithPath:@"http://api.acplay.net:8089/api/v1/homepage?userId=0&token=0" parameters:nil completionHandler:^(NSDictionary *responseObj, DanDanPlayErrorModel *error) {
//        BangumiModel *bangumiModel;
        FeaturedModel *featuredModel;
        NSMutableArray *bangumis = [NSMutableArray array];
        
        NSArray *interestListArr = responseObj[@"InterestList"];
        if (interestListArr.count > 0) {
            featuredModel = [FeaturedModel yy_modelWithDictionary:interestListArr[1]];
        }
        
        if (interestListArr.count > 1) {
            NSInteger weekDay = [self weekDay];
            NSArray *bangumiOfDaysArr = interestListArr[2][@"BangumiOfDays"];
            NSInteger count = bangumiOfDaysArr.count;
            for (NSInteger i = 0; i < count; ++i) {
                NSDictionary *dic = bangumiOfDaysArr[(i + weekDay) % count];
                [bangumis addObject:[BangumiModel yy_modelWithDictionary:dic]];
            }
//            if (bangumiOfDaysArr.count > weekDay) {
//                bangumiModel = [BangumiModel yy_modelWithDictionary:bangumiOfDaysArr[weekDay]];
//            }
        }
        
        complete(featuredModel, bangumis, error);
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
