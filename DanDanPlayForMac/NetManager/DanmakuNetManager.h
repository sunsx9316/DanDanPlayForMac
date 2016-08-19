//
//  DanmakuNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"
@class DanMuDataModel;
@interface DanmakuNetManager : BaseNetManager
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
 *  批量获取视频详情
 *
 *  @param aids 视频aid数组
 *  @param complete 回调
 */
+ (void)batchGETDanmakuInfoWithAids:(NSArray <NSString *>*)aids source:(DanDanPlayDanmakuSource)source completionHandler:(void(^)(NSArray *responseObjs, NSArray <NSURLSessionTask *>*tasks))complete;

/**
 *  批量下载弹幕
 *
 *  @param danmakuIds    弹幕id
 *  @param source        来源
 *  @param progressBlock 进度回调
 *  @param complete      完成回调
 */
+ (void)batchDownDanmakuWithDanmakuIds:(NSArray <NSString *>*)danmakuIds
                                source:(DanDanPlayDanmakuSource)source
                         progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations, id *responseObj))progressBlock
                     completionHandler:(void(^)(NSArray *responseObjs, NSArray <NSURLSessionTask *>*tasks))complete;
/**
 *  获取b站弹幕详情
 *
 *  @param aid      视频 aid
 *  @param page     分页
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETBiliBiliDanmakuInfoWithAid:(NSString *)aid page:(NSUInteger)page completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  获取a站弹幕详情
 *
 *  @param aid        视频aid
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETAcfunDanmakuInfoWithAid:(NSString *)aid completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
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
