//
//  DanMuNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"
@class DanMuDataModel;
@interface DanMuNetManager : BaseNetManager
/**
 *  下载官方或第三方弹幕库
 *
 *  @param parameters 参数 节目id
 *  @param complete   回调 在官方弹幕库不为空时 直接返回官方弹幕库；为空时 返回对应的番剧分集信息
 *
 *  @return 任务
 */
+ (id)GETWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  下载官方弹幕
 *
 *  @param parameters parameters 参数 节目id
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)downOfficialDanmakuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  下载第三方弹幕
 *
 *  @param parameters 参数 danmaku:弹幕库id provider 提供者
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)downThirdPartyDanMuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取b站视频详情
 *
 *  @param parameters 参数 aid page
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)GETBiliBiliDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  获取a站视频详情
 *
 *  @param parameters aid:视频aid
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)GETAcfunDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  发射弹幕方法
 *
 *  @param model     弹幕模型
 *  @param episodeId 节目id
 *  @param complete  回调
 *
 *  @return 任务
 */
+ (id)launchDanmakuWithModel:(DanMuDataModel *)model episodeId:(NSString *)episodeId completionHandler:(void(^)(NSError *error))complete;
@end
