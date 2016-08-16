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
+ (NSURLSessionDataTask *)GETWithProgramId:(NSString *)programId completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  下载官方弹幕
 *
 *  @param programId programId 参数 节目id
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)downOfficialDanmakuWithProgramId:(NSString *)programId completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;

+ (void)batchDownloadThirdPartyDanmakuWithProvider:(NSArray <NSNumber *>*)sources danmakus:(NSArray <NSString *>*)danmakus;
/**
 *  下载第三方弹幕
 *
 *  @param parameters 参数 danmaku:弹幕库id provider 提供者
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)downThirdPartyDanmakuWithDanmaku:(NSString *)danmaku provider:(DanDanPlayDanmakuSource)provider completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  获取b站弹幕详情
 *
 *  @param aid      视频 aid
 *  @param page     分页
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETBiliBiliDanmakuWithAid:(NSString *)aid page:(NSUInteger)page completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  获取a站弹幕详情
 *
 *  @param aid        视频aid
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETAcfunDanmakuWithAid:(NSString *)aid completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  发射弹幕方法
 *
 *  @param model     弹幕模型
 *  @param episodeId 节目id
 *  @param complete  回调
 *
 *  @return 任务
 */
+ (id)launchDanmakuWithModel:(DanMuDataModel *)model episodeId:(NSString *)episodeId completionHandler:(void(^)(DanDanPlayErrorModel *error))complete;
@end
