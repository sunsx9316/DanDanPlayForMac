//
//  DanMuNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface DanMuNetManager : BaseNetManager
/**
 *  获取弹幕库
 *
 *  @param parameters 参数 节目id
 *  @param complete   回调 在官方弹幕库不为空时 直接返回官方弹幕库；为空时 返回对应的番剧分集信息
 *
 *  @return 任务
 */
+ (id)getWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  下载第三方弹幕
 *
 *  @param parameters 参数 danmuku:弹幕库id provider 提供者
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)downThirdPartyDanMuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取b站视频详情
 *
 *  @param parameters 参数
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getBiliBiliDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取a站视频详情
 *
 *  @param parameters aid:视频aid
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getAcfunDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
