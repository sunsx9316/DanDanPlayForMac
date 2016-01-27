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
@end
