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

static NSString *official = @"official";
static NSString *bilibili = @"bilibili";
static NSString *acfun = @"acfun";

@implementation DanMuNetManager
+ (id)getWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (![UserDefaultManager turnOnFastMatch]) {
        //没开启快速匹配功能 直接进入匹配界面
       return [self getThirdPartyDanMuWithParameters:parameters completionHandler:complete];
    }else{
        return [self downOfficialDanmakuWithParameters:parameters completionHandler:^(id responseObj, NSError *error) {
            //如果返回的对象不为空 说明有官方弹幕库 同时开启了快速匹配 直接返回 否则请求第三方弹幕库
            if ([responseObj count]) {
                complete(responseObj, error);
            }else{
                [self getThirdPartyDanMuWithParameters:parameters completionHandler:complete];
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
    id cache = [self danMuCacheWithDanmakuID:parameters[@"id"] provider:official];
    if (cache) {
        complete([DanMuDataFormatter dicWithObj:[DanMuModel yy_modelWithDictionary: cache].comments source:JHDanMuSourceOfficial], nil);
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
        complete(nil, nil);
        return nil;
    }
    
    if ([parameters[@"provider"] isEqualToString: bilibili]) {
        //找缓存
        id cache = [self danMuCacheWithDanmakuID:parameters[@"danmaku"] provider:bilibili];
        if (cache) {
            complete([DanMuDataFormatter dicWithObj:cache source:JHDanMuSourceBilibili], nil);
            return nil;
        }
        
        return [self GETDataWithPath:[@"http://comment.bilibili.com/" stringByAppendingFormat:@"%@.xml",parameters[@"danmaku"]] parameters:nil completionHandler:^(NSData *responseObj, NSError *error) {
            //写入缓存
            [self writeDanMuCacheWithProvider:bilibili danmakuID:parameters[@"danmaku"] responseObj:responseObj];
            
            complete([DanMuDataFormatter dicWithObj:responseObj source:JHDanMuSourceBilibili], error);
        }];
    }else if ([parameters[@"provider"] isEqualToString: acfun]){
        //找缓存
        id cache = [self danMuCacheWithDanmakuID:parameters[@"danmaku"] provider:acfun];
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


+ (id)getBiliBiliDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://biliproxy.chinacloudsites.cn/av/46431/1?list=1
    if (!parameters[@"aid"]) {
        complete(nil, kObjNilError);
        return nil;
    }
    //分页 可选参数
    NSString *page = ([parameters[@"page"] intValue])?parameters[@"page"]:@"1";
    
    return [self GETWithPath:[NSString stringWithFormat:@"http://biliproxy.chinacloudsites.cn/av/%@/%@?list=1", parameters[@"aid"], page] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        if ([responseObj isKindOfClass:[NSDictionary class]] && responseObj.count) {
            NSDictionary *dic = responseObj[@"parts"];
            if (!dic) {
                NSString *title = responseObj[@"title"]?responseObj[@"title"]:@"";
                NSString *danmaku = responseObj[@"cid"]?responseObj[@"cid"]:@"";
                complete([BiliBiliVideoInfoModel yy_modelWithDictionary: @{@"title":title, @"videos":@[@{@"title":title, @"danmaku":danmaku}]}], error);
            }else{
                NSArray *allSortedKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
                    return obj1.integerValue < obj2.integerValue;
                }];
                NSInteger danmaku = [responseObj[@"cid"] integerValue];
                NSMutableArray *videosArr = [NSMutableArray array];
                [allSortedKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [videosArr addObject:@{@"title":[NSString stringWithFormat:@"%@: %@", obj, dic[obj]], @"danmaku":[NSString stringWithFormat:@"%ld", danmaku + idx]}];
                }];
                complete([BiliBiliVideoInfoModel yy_modelWithDictionary: @{@"title":responseObj[@"title"]?responseObj[@"title"]:@"", @"videos":videosArr}], error);
            }
        }
    }];
}

+ (id)getAcfunDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://www.talkshowcn.com/video/getVideo.aspx?id=435639 黑科技
    return [self GETWithPath:[NSString stringWithFormat:@"http://www.talkshowcn.com/video/getVideo.aspx?id=%@", parameters[@"aid"]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        //黑科技只解析单个视频的信息 故把字典封装成数组才可解析
        if (!responseObj) {
            complete(nil, nil);
            return;
        }
        
        complete([AcfunVideoInfoModel yy_modelWithDictionary: @{@"videos":@[responseObj], @"title":responseObj[@"title"]}], error);
    }];
}


+ (id)launchDanmakuWithModel:(DanMuDataModel *)model episodeId:(NSString *)episodeId completionHandler:(void(^)(NSError *error))complete{
    if (!model || !episodeId) {
        complete(kObjNilError);
        return nil;
    }
    return [self PUTWithPath:[NSString stringWithFormat:@"http://acplay.net/api/v1/comment/%@?clientId=ddplaymac", episodeId] HTTPBody:[[[model launchDanmakuModel] yy_modelToJSONData] Encrypt] parameters:nil completionHandler:^(id responseObj, NSError *error) {
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
+ (id)getThirdPartyDanMuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://acplay.net/api/v1/related/111240001
    return [self GETWithPath:[@"http://acplay.net/api/v1/related/" stringByAppendingString: parameters[@"id"]] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
        NSArray <NSDictionary *>*relateds = responseObj[@"Relateds"];
        //装视频详情的字典
        NSMutableDictionary <NSString *, NSMutableArray *> *videoInfoDic = [NSMutableDictionary dictionary];
        NSMutableArray *requestArr = [NSMutableArray array];
        
        for (NSDictionary *obj in relateds) {
            //视频提供者是a站
            if ([obj[@"Provider"] isEqualToString:@"Acfun.tv"]) {
                [requestArr addObject: [self getAcfunDanMuWithParameters:[self acfunAidWithPath: obj[@"Url"]] completionHandler:^(id responseObj, NSError *error) {
                    if (!videoInfoDic[@"acfun"]) videoInfoDic[@"acfun"] = [NSMutableArray array];
                    if (responseObj) [videoInfoDic[@"acfun"] addObject: responseObj];
                }]];
                //视频提供者是b站
            }else if ([obj[@"Provider"] isEqualToString:@"BiliBili.com"]){
                [requestArr addObject: [self getBiliBiliDanMuWithParameters:[self bilibiliAidWithPath: obj[@"Url"]] completionHandler:^(id responseObj, NSError *error) {
                    if (!videoInfoDic[@"bilibili"]) videoInfoDic[@"bilibili"] = [NSMutableArray array];
                    if (responseObj) [videoInfoDic[@"bilibili"] addObject: responseObj];
                }]];
            }
        }
        
        NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:requestArr progressBlock: nil completionBlock:^(NSArray *operations) {
            complete(videoInfoDic, error);
        }];
        [[NSOperationQueue mainQueue] addOperations:@[operations.lastObject] waitUntilFinished:NO];
    }];
}

/**
 *  获取b站视频av号 分集
 *
 *  @param path url
 *
 *  @return av号 分集
 */
+ (NSDictionary *)bilibiliAidWithPath:(NSString *)path{
    //http://www.bilibili.com/video/av46431/index_2.html
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *obj in arr) {
        if ([obj hasPrefix: @"av"]){
            dic[@"aid"] = [obj substringFromIndex: 2];
        }else if ([obj hasPrefix: @"index"]){
            dic[@"index"] = [[obj componentsSeparatedByString: @"."].firstObject componentsSeparatedByString: @"_"].lastObject;
        }
    }
    return dic;
}
/**
 *  获取a站av号 分集
 *
 *  @param path url
 *
 *  @return av号 分集
 */
+ (NSDictionary *)acfunAidWithPath:(NSString *)path{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *arr = [[path componentsSeparatedByString: @"/"].lastObject componentsSeparatedByString:@"_"];
    if (arr.count == 2) dic[@"index"] = arr.lastObject;
    dic[@"aid"] = [arr.firstObject substringFromIndex: 2];
    return dic;
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
+ (id)danMuCacheWithDanmakuID:(NSString *)danmakuID provider:(NSString *)provider{
    
    NSString *danMuCachePath = [[UserDefaultManager cachePath] stringByAppendingPathComponent:[provider stringByAppendingPathComponent:danmakuID]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile: danMuCachePath];
}
@end
