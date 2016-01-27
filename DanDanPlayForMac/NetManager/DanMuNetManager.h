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
 *  @param parameters 参数 id
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
@end
