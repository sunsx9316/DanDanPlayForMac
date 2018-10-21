//
//  RecommedNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommedNetManager.h"
#import "GDataXMLElement+Tools.h"
//#import <GDataXMLNode.h>
//#import "FeaturedModel.h"
//#import "BangumiModel.h"

@implementation RecommedNetManager
+ (NSURLSessionDataTask *)recommedInfoWithCompletionHandler:(void(^)(JHHomePage *responseObject, DanDanPlayErrorModel *error))completionHandler {
    
    if (completionHandler == nil) {
        return nil;
    }
    
    return [self GETDataWithPath:[NSString stringWithFormat:@"%@/homepage?userId=0&token=0", [DDPMethod apiPath]] parameters:nil headerField:@{@"Accept" : @"application/xml"} completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
        if (error) {
            completionHandler(nil, error);
        }
        else {
            NSError *err;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObj error:&err];
            
            if (err == nil) {
                JHHomePage *homePageModel = [[JHHomePage alloc] init];
                homePageModel.bangumis = [NSMutableArray array];
                homePageModel.bannerPages = [NSMutableArray array];
                GDataXMLElement *rootElement = document.rootElement;
                //滚动视图
                GDataXMLElement *aElement = [rootElement elementsForName:@"Banner"].firstObject;
                NSArray *aElements = [aElement elementsForName:@"BannerPage"];
                
                for (GDataXMLElement *element in aElements) {
                    JHBannerPage *model = [JHBannerPage yy_modelWithDictionary:[element keysValuesForElementKeys:@[@"Title", @"Description", @"ImageUrl", @"Url"]]];
                    [(NSMutableArray *)homePageModel.bannerPages addObject:model];
                }
                
                //每日推荐
                aElement = [rootElement elementsForName:@"Featured"].firstObject;
                JHFeatured *featuredModel = [JHFeatured yy_modelWithDictionary:[aElement keysValuesForElementKeys:@[@"Title", @"ImageUrl", @"Category", @"Introduction", @"Url"]]];
                homePageModel.todayFeaturedModel = featuredModel;
                
                //推荐番剧
                aElement = [rootElement elementsForName:@"Bangumi"].firstObject;
                aElements = [aElement elementsForName:@"BangumiOfDay"];
                
                for (GDataXMLElement *element in aElements) {
                    NSDictionary *dic = [element keysValuesForElementKeys:@[@"DayOfWeek", @"Bangumi"]];
                    JHBangumiCollection *model = [[JHBangumiCollection alloc] init];
                    model.weekDay = [dic[@"DayOfWeek"] integerValue];
                    model.collection = [NSMutableArray array];
                    [(NSMutableArray *)homePageModel.bangumis addObject:model];
                    
                    for (GDataXMLElement *aBangumiElement in dic[@"Bangumi"]) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[aBangumiElement keysValuesForElementKeys:@[@"Name", @"Keyword", @"ImageUrl", @"AnimeId", @"IsFavorite", @"Groups"]]];
                        
                        NSArray *groupsArr = [dic[@"Groups"] elementsForName:@"Group"];
                        dic[@"Groups"] = [NSMutableArray array];
                        for (GDataXMLElement *aGroupsElement in groupsArr) {
                            JHBangumiGroup *groupModel = [JHBangumiGroup yy_modelWithDictionary:[aGroupsElement keysValuesForAttributeKeys:@[@"GroupName", @"SearchUrl"]]];
                            [dic[@"Groups"] addObject:groupModel];
                        }
                        
                        JHBangumi *bangumiDataModel = [JHBangumi yy_modelWithDictionary:dic];
                        [model.collection addObject:bangumiDataModel];
                    }
                }
                
                completionHandler(homePageModel, [DanDanPlayErrorModel errorWithError:err]);
            }
            else {
                completionHandler(nil, [DanDanPlayErrorModel errorWithError:err]);
            }
        }
    }];
}

#pragma mark - 私有方法
/**
 *  获取今天星期
 *
 *  @return 1~6对应星期一~六 0对应星期天
 */
+ (NSInteger)weekDay {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    return [comps weekday] - 1;
}

//+ (NSURLSessionDataTask *)recommedInfoWithCompletionHandler:(void(^)(FeaturedModel *featuredModel, NSArray *bangumis, DanDanPlayErrorModel *error))complete {
//    return [self GETWithPath:[NSString stringWithFormat:@"%@/homepage?userId=0&token=0", [DDPMethod apiPath]] parameters:nil completionHandler:^(NSDictionary *responseObj, DanDanPlayErrorModel *error) {
////        BangumiModel *bangumiModel;
//        FeaturedModel *featuredModel;
//        NSMutableArray *bangumis = [NSMutableArray array];
//        
//        NSArray *interestListArr = responseObj[@"InterestList"];
//        if (interestListArr.count > 0) {
//            featuredModel = [FeaturedModel yy_modelWithDictionary:interestListArr[1]];
//        }
//        
//        if (interestListArr.count > 1) {
//            NSInteger weekDay = [self weekDay];
//            NSArray *bangumiOfDaysArr = interestListArr[2][@"BangumiOfDays"];
//            NSInteger count = bangumiOfDaysArr.count;
//            for (NSInteger i = 0; i < count; ++i) {
//                NSDictionary *dic = bangumiOfDaysArr[(i + weekDay) % count];
//                [bangumis addObject:[BangumiModel yy_modelWithDictionary:dic]];
//            }
////            if (bangumiOfDaysArr.count > weekDay) {
////                bangumiModel = [BangumiModel yy_modelWithDictionary:bangumiOfDaysArr[weekDay]];
////            }
//        }
//        
//        complete(featuredModel, bangumis, error);
//    }];
//}
//
//#pragma mark - 私有方法
///**
// *  获取今天星期
// *
// *  @return 1~6对应星期一~六 0对应星期天
// */
//+ (NSInteger)weekDay{
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
//    return [comps weekday] - 1;
//}
@end
