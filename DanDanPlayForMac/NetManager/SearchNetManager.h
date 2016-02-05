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
 *  搜索请求
 *
 *  @param parameters 参数 anime episode
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(SearchModel* responseObj, NSError *error))complete;
/**
 *  搜索b站结果
 *
 *  @param parameters keyword
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)searchBiliBiliWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取番剧详情
 *
 *  @param parameters seasonID
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)searchBiliBiliSeasonInfoWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
