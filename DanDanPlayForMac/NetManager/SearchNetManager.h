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
 *  @param parameters 参数 anime episode
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(SearchModel* responseObj, NSError *error))complete;
/**
 *  搜索b站结果
 *
 *  @param parameters keyword 关键字
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchBiliBiliWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取b站番剧详情
 *
 *  @param parameters seasonID 剧集id
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchBiliBiliSeasonInfoWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  搜索a站结果
 *
 *  @param parameters keyword 关键字
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchAcFunWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取a站番剧详情
 *
 *  @param parameters seasonID 剧集id
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)searchAcfunSeasonInfoWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
