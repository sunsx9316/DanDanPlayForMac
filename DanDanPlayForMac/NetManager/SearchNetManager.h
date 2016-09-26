//
//  SearchNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"
@class SearchModel;
@interface SearchNetManager : BaseNetManager
/**
 *  官方搜索请求
 *
 *  @param animeName 动画标题
 *  @param episode   分集
 *  @param complete  回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETWithAnimeName:(NSString *)animeName episode:(NSString *)episode completionHandler:(void(^)(SearchModel* responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  搜索b站结果
 *
 *  @param keyword  关键字
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchBiliBiliWithkeyword:(NSString *)keyword completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  获取b站番剧详情
 *
 *  @param seasonId 番剧id
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchBiliBiliSeasonInfoWithSeasonId:(NSString *)seasonId completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  搜索a站结果
 *
 *  @param keyword  关键字
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchAcFunWithKeyword:(NSString *)keyword completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  获取a站番剧详情
 *
 *  @param parameters seasonID 剧集id
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchAcfunSeasonInfoWithSeasonId:(NSString *)seasonId completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
@end
