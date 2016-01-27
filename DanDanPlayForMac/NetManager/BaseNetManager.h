//
//  BaseNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetManager : NSObject
/**
 *  GET封装
 *
 *  @param path       路径
 *  @param parameters 参数
 *  @param complete   完成回调
 *
 *  @return 任务
 */
+ (id)getWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  GET封装 直接获取data
 *
 *  @param path       路径
 *  @param parameters 参数
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
