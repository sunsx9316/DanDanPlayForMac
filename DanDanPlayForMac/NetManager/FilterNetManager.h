//
//  FilterNetManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface FilterNetManager : BaseNetManager
/**
 *  获取云过滤列表
 *
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)filterWithCompletionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
