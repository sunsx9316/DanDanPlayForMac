//
//  DanMuNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DanMuNetManager.h"
#import "DanMuModel.h"
#import "VideoInfoModel.h"
#import "DanMuDataFormatter.h"
#import "NSData+DanDanPlay.h"
#import "ParentDanmaku.h"
#import "AFHTTPSessionManager+Batch.h"
#import "NSString+Tools.h"

@implementation DanMuNetManager
+ (id)GETWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (![UserDefaultManager turnOnFastMatch]) {
        //没开启快速匹配功能 直接进入匹配界面
       return [self GETThirdPartyDanMuWithParameters:parameters completionHandler:complete];
    }else{
        return [self downOfficialDanmakuWithParameters:parameters completionHandler:^(id responseObj, NSError *error) {
            //如果返回的对象不为空 说明有官方弹幕库 同时开启了快速匹配 直接返回 否则请求第三方弹幕库
            if ([responseObj count]) {
                complete(responseObj, error);
            }else{
                [self GETThirdPartyDanMuWithParameters:parameters completionHandler:complete];
            }
        }];
    }
}

+ (id)downOfficialDanmakuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (![parameters[@"id"] length]) {
        complete(nil, nil);
        return nil;
    }
    //找缓存
    id cache = [self danMuCacheWithDanmakuID:parameters[@"id"] provider:official isCache:NO];
    if (cache) {
        cache = [DanMuDataFormatter dicWithObj:[DanMuModel yy_modelWithDictionary: cache].comments source:JHDanMuSourceOfficial];
        //找用户发送缓存
        id userCache = [self danMuCacheWithDanmakuID:parameters[@"id"] provider:official isCache:YES];
        if (userCache) {
            userCache = [DanMuDataFormatter arrWithObj:userCache source:JHDanMuSourceCache];
            [userCache enumerateObjectsUsingBlock:^(ParentDanmaku * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger time = obj.appearTime;
                if (!cache[@(time)]) {
                    cache[@(time)] = [NSMutableArray array];
                }
                [cache[@(time)] addObject:obj];
            }];
        }
        
        complete(cache, nil);
        return nil;
    }
    
    return [self GETWithPath:[@"http://acplay.net/api/v1/comment/" stringByAppendingString: parameters[@"id"]] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        //写入缓存
        [self writeDanMuCacheWithProvider:official danmakuID:parameters[@"id"] responseObj:responseObj];
        complete([DanMuDataFormatter dicWithObj:[DanMuModel yy_modelWithDictionary: responseObj].comments source:JHDanMuSourceOfficial], error);
    }];
}

+ (id)downThirdPartyDanMuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    // danmaku:弹幕库id provider 提供者
    if (![parameters[@"danmaku"] length] || ![parameters[@"provider"] length]) {
        complete(nil, kObjNilError);
        return nil;
    }
    
    if ([parameters[@"provider"] isEqualToString: bilibili]) {
        //找缓存
        id cache = [self danMuCacheWithDanmakuID:parameters[@"danmaku"] provider:bilibili isCache:NO];
        if (cache) {
            complete([DanMuDataFormatter dicWithObj:cache source:JHDanMuSourceBilibili], nil);
            return nil;
        }
        
        NSString *path = [@"http://comment.bilibili.com/" stringByAppendingFormat:@"%@.xml",parameters[@"danmaku"]];
        
        return [self GETWithPath:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
            //写入缓存
            [self writeDanMuCacheWithProvider:bilibili danmakuID:parameters[@"danmaku"] responseObj:responseObj];
            
            complete([DanMuDataFormatter dicWithObj:responseObj source:JHDanMuSourceBilibili], error);
        }];
        
//        return [self GETDataWithPath:[@"http://comment.bilibili.com/" stringByAppendingFormat:@"%@.xml",parameters[@"danmaku"]] parameters:nil completionHandler:^(NSData *responseObj, NSError *error) {
//            //写入缓存
//            [self writeDanMuCacheWithProvider:bilibili danmakuID:parameters[@"danmaku"] responseObj:responseObj];
//            
//            complete([DanMuDataFormatter dicWithObj:responseObj source:JHDanMuSourceBilibili], error);
//        }];
    }
    else if ([parameters[@"provider"] isEqualToString: acfun]){
        //找缓存
        id cache = [self danMuCacheWithDanmakuID:parameters[@"danmaku"] provider:acfun isCache:NO];
        if (cache) {
            complete([DanMuDataFormatter dicWithObj:cache source:JHDanMuSourceAcfun], nil);
            return nil;
        }
        
        //http://danmu.aixifan.com/3037718
        return [self GETWithPath:[@"http://danmu.aixifan.com/" stringByAppendingString: parameters[@"danmaku"]] parameters:nil completionHandler:^(NSArray <NSArray *>*responseObj, NSError *error) {
            //写入缓存
            [self writeDanMuCacheWithProvider:acfun danmakuID:parameters[@"danmaku"] responseObj:responseObj];
            complete([DanMuDataFormatter dicWithObj:responseObj source:JHDanMuSourceAcfun], error);
        }];
    }
    return nil;
}


+ (id)GETBiliBiliDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://biliproxy.chinacloudsites.cn/av/46431/1?list=1
    return [self GETWithPath:[self bilibiliDanmakuInfoRequestPathWithAid:parameters[@"aid"] page:parameters[@"page"]] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        complete([self pareBiliBiliVideoInfoModelWithDic:responseObj], error);
    }];
}

+ (id)GETAcfunDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete {
    //http://www.talkshowcn.com/video/getVideo.aspx?id=435639 黑科技
    return [self GETWithPath:[self acfunDanmakuInfoRequestPathWithAid:parameters[@"aid"]] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        complete([self pareAcfunVideoInfoModelWithDic:responseObj], error);
    }];
}


+ (id)launchDanmakuWithModel:(DanMuDataModel *)model episodeId:(NSString *)episodeId completionHandler:(void(^)(NSError *error))complete{
    if (!model || !episodeId) {
        complete(kObjNilError);
        return nil;
    }
    return [self PUTWithPath:[NSString stringWithFormat:@"http://acplay.net/api/v1/comment/%@?clientId=ddplaymac", episodeId] HTTPBody:[[[model launchDanmakuModel] yy_modelToJSONData] Encrypt] completionHandler:^(id responseObj, NSError *error) {
        complete(error);
    }];
}

#pragma mark - 私有方法
/**
 *  获取第三方弹幕库
 *
 *  @param parameters 参数字典
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)GETThirdPartyDanMuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete {
#warning TODO
    //http://acplay.net/api/v1/related/111240001
    
    NSString *path = [@"http://acplay.net/api/v1/related/" stringByAppendingString: parameters[@"id"]];
    [self GETWithPath:path parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray <NSDictionary *>*relateds = responseObj[@"Relateds"];
            NSMutableArray *paths = [NSMutableArray array];
            //装视频详情的字典
            NSMutableDictionary <NSString *, NSMutableArray *> *videoInfoDic = [NSMutableDictionary dictionary];
            for (NSDictionary *obj in relateds) {
                //视频提供者是a站
                if ([obj[@"Provider"] isEqualToString:@"Acfun.tv"]) {
                    [self acfunAidWithPath:obj[@"Url"] complectionHandler:^(NSString *aid, NSString *index) {
                        [paths addObject:[self acfunDanmakuInfoRequestPathWithAid:aid]];
                    }];
                    //视频提供者是b站
                }
                else if ([obj[@"Provider"] isEqualToString:@"BiliBili.com"]) {
                    [self bilibiliAidWithPath:obj[@"Url"] complectionHandler:^(NSString *aid, NSString *page) {
                        [paths addObject:[self bilibiliDanmakuInfoRequestPathWithAid:aid page:page]];
                    }];
                }
            }
            
            [AFHTTPSessionManager batchGETWithPaths:paths progressBlock:nil completionBlock:^(NSArray *responseObjects, NSArray<NSURLSessionTask *> *tasks) {
                [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSURLSessionTask class]]) {
                        if ([obj.currentRequest.URL.path containsString:@"biliproxy"]) {
                            if (!videoInfoDic[bilibili]) {
                                videoInfoDic[bilibili] = [NSMutableArray array];
                            }
                            BiliBiliVideoInfoModel *model = [self pareBiliBiliVideoInfoModelWithDic:responseObj];
                            if (model) {
                                [videoInfoDic[bilibili] addObject:model];
                            }
                        }
                        else {
                            if (!videoInfoDic[acfun]) {
                                videoInfoDic[acfun] = [NSMutableArray array];
                            }
                            AcfunVideoInfoModel *model = [self pareAcfunVideoInfoModelWithDic:responseObj];
                            if (model) {
                                [videoInfoDic[acfun] addObject:model];
                            }
                        }
                    }
                }];
            }];
        }
    }];
    
    
//    return [self GETWithPath:[@"http://acplay.net/api/v1/related/" stringByAppendingString: parameters[@"id"]] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
//        NSArray <NSDictionary *>*relateds = responseObj[@"Relateds"];
//        //装视频详情的字典
//        NSMutableDictionary <NSString *, NSMutableArray *> *videoInfoDic = [NSMutableDictionary dictionary];
//        NSMutableArray *requestArr = [NSMutableArray array];
//        
//        for (NSDictionary *obj in relateds) {
//            //视频提供者是a站
//            if ([obj[@"Provider"] isEqualToString:@"Acfun.tv"]) {
//                [requestArr addObject: [self GETAcfunDanMuWithParameters:[self acfunAidWithPath: obj[@"Url"]] completionHandler:^(id responseObj, NSError *error) {
//                    if (!videoInfoDic[@"acfun"]) videoInfoDic[@"acfun"] = [NSMutableArray array];
//                    if (responseObj) [videoInfoDic[@"acfun"] addObject: responseObj];
//                }]];
//                //视频提供者是b站
//            }
//            else if ([obj[@"Provider"] isEqualToString:@"BiliBili.com"]){
//                [requestArr addObject: [self GETBiliBiliDanMuWithParameters:[self bilibiliAidWithPath: obj[@"Url"]] completionHandler:^(id responseObj, NSError *error) {
//                    if (!videoInfoDic[@"bilibili"]) videoInfoDic[@"bilibili"] = [NSMutableArray array];
//                    if (responseObj) [videoInfoDic[@"bilibili"] addObject: responseObj];
//                }]];
//            }
//        }
//        
//        NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:requestArr progressBlock: nil completionBlock:^(NSArray *operations) {
//            complete(videoInfoDic, error);
//        }];
//        [[NSOperationQueue mainQueue] addOperations:@[operations.lastObject] waitUntilFinished:NO];
//    }];
    return nil;
}

/**
 *  获取b站视频av号 分集
 *
 *  @param path       路径
 *  @param completion 回调
 */
+ (void)bilibiliAidWithPath:(NSString *)path complectionHandler:(void(^)(NSString *aid, NSString *page))completion {
    //http://www.bilibili.com/video/av46431/index_2.html
    if (!path) {
        completion(nil, nil);
    }
    
    NSString *aid;
    NSString *index;
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    for (NSString *obj in arr) {
        if ([obj hasPrefix: @"av"]) {
            aid = [obj substringFromIndex: 2];
        }
        else if ([obj hasPrefix: @"index"]) {
            index = [[obj componentsSeparatedByString: @"."].firstObject componentsSeparatedByString: @"_"].lastObject;
        }
    }
    completion(aid, index);
}
/**
 *  获取a站av号 分集
 *
 *  @param path url
 *
 *  @return av号 分集
 */
+ (void)acfunAidWithPath:(NSString *)path complectionHandler:(void(^)(NSString *aid, NSString *index))completion {
    if (!path) {
        completion(nil, nil);
    }
    
    NSString *aid;
    NSString *index;
    NSArray *arr = [[path componentsSeparatedByString: @"/"].lastObject componentsSeparatedByString:@"_"];
    if (arr.count == 2) {
        index = arr.lastObject;
        aid = [arr.firstObject substringFromIndex: 2];
    }
    completion(aid, index);
}

/**
 *  将弹幕写入缓存
 *
 *  @param provider    提供者
 *  @param danmakuID   弹幕id
 *  @param responseObj 弹幕内容
 */
+ (void)writeDanMuCacheWithProvider:(NSString *)provider danmakuID:(NSString *)danmakuID responseObj:(id)responseObj{
    //将弹幕写入缓存
    NSString *cachePath = [[UserDefaultManager cachePath] stringByAppendingPathComponent:provider];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSKeyedArchiver archiveRootObject:responseObj toFile:[cachePath stringByAppendingPathComponent:danmakuID]];
    });
}

/**
 *  拿到弹幕缓存
 *
 *  @param danmakuID 弹幕id
 *  @param provider  提供者
 *
 *  @return 弹幕缓存
 */
+ (id)danMuCacheWithDanmakuID:(NSString *)danmakuID provider:(NSString *)provider isCache:(BOOL)isCache{
    NSString *danMuCachePath = [[UserDefaultManager cachePath] stringByAppendingPathComponent:[provider stringByAppendingPathComponent:!isCache ? danmakuID : [NSString stringWithFormat:@"%@_user", danmakuID]]];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile: danMuCachePath];
}

/**
 *  转换 bilibili 视频模型
 *
 *  @param dic 字典模型
 *
 *  @return bilibili 视频模型
 */
+ (BiliBiliVideoInfoModel *)pareBiliBiliVideoInfoModelWithDic:(NSDictionary *)responseObj {
    if ([responseObj isKindOfClass:[NSDictionary class]] && responseObj.count) {
        NSDictionary *tempDic = responseObj[@"parts"];
        //包含分集的情况
        if (tempDic == nil) {
            NSString *title = responseObj[@"title"] ? responseObj[@"title"] : @"";
            NSString *danmaku = responseObj[@"cid"] ? responseObj[@"cid"] : @"";
            return [BiliBiliVideoInfoModel yy_modelWithDictionary: @{@"title":title, @"videos":@[@{@"title":title, @"danmaku":danmaku}]}];
        }
        else {
            NSArray *allSortedKeys = [tempDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
                return obj1.integerValue > obj2.integerValue;
            }];
            NSInteger danmaku = [responseObj[@"cid"] integerValue];
            NSMutableArray *videosArr = [NSMutableArray array];
            [allSortedKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [videosArr addObject:@{@"title":[NSString stringWithFormat:@"%@: %@", obj, tempDic[obj]], @"danmaku":[NSString stringWithFormat:@"%ld", danmaku + idx]}];
            }];
            return [BiliBiliVideoInfoModel yy_modelWithDictionary: @{@"title":responseObj[@"title"] ? responseObj[@"title"] : @"", @"videos":videosArr}];
        }
    }
    return nil;
}

/**
 *  转换 acfun 的视频模型
 *
 *  @param dic 字典模型
 *
 *  @return acfun 的视频模型
 */
+ (AcfunVideoInfoModel *)pareAcfunVideoInfoModelWithDic:(NSDictionary *)dic {
    //黑科技只解析单个视频的信息 故把字典封装成数组才可解析
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *title = dic[@"title"];
        if (!title.length) {
            return [AcfunVideoInfoModel yy_modelWithDictionary: @{@"videos":@[dic], @"title":title}];
        }
    }
    return nil;
}
/**
 *  bilibili 视频弹幕详情的路径
 *
 *  @param aid  视频 aid
 *  @param page 分页
 *
 *  @return 路径
 */
+ (NSString *)bilibiliDanmakuInfoRequestPathWithAid:(NSString *)aid page:(NSString *)page {
    if (!page.length) {
        page = @"1";
    }
    return [NSString stringWithFormat:@"http://biliproxy.chinacloudsites.cn/av/%@/%@?list=1", aid, page];
}

 /**
 *  acfun 视频弹幕详情的路径
 *
 *  @param aid  视频 aid
 *
 *  @return 路径
 */
+ (NSString *)acfunDanmakuInfoRequestPathWithAid:(NSString *)aid {
    return [NSString stringWithFormat:@"http://www.talkshowcn.com/video/getVideo.aspx?id=%@", aid];
}

@end
