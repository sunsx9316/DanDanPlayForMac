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
//#import "NSDictionary+Tools.h"
#import "DanMuModelArr2Dic.h"

@implementation DanMuNetManager
+ (id)getWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!parameters[@"id"]) return nil;
    
    return [self getWithPath:[@"http://acplay.net/api/v1/comment/" stringByAppendingString: parameters[@"id"]] parameters:@{@"from":@"0"} completionHandler:^(NSDictionary *responseObj, NSError *error) {
        //如果返回的对象不为空 说明有官方弹幕库 直接返回 否则请求第三方弹幕库
        if ([responseObj[@"Comments"] count]) {
            complete([DanMuModelArr2Dic dicWithObj:[DanMuModel yy_modelWithDictionary: responseObj].comments source:official], error);
        }else{
            [self getThirdPartyDanMuWithParameters:parameters completionHandler:complete];
        }
    }];
}

+ (id)downThirdPartyDanMuWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    // danmuku:弹幕库id provider 提供者
    if (!parameters[@"danmuku"] || !parameters[@"provider"]) {
        complete(nil, nil);
        return nil;
    }
    
    if ([parameters[@"provider"] isEqualToString: @"bilibili"]) {
        return [self getDataWithPath:[@"http://comment.bilibili.com/" stringByAppendingFormat:@"%@.xml",parameters[@"danmuku"]] parameters:nil completionHandler:^(NSData *responseObj, NSError *error) {
            complete([DanMuModelArr2Dic dicWithObj:responseObj source:bilibili], error);
        }];
    }else if ([parameters[@"provider"] isEqualToString: @"acfun"]){
        //http://danmu.aixifan.com/3037718
        return [self getWithPath:[@"http://danmu.aixifan.com/" stringByAppendingString: parameters[@"danmuku"]] parameters:nil completionHandler:^(NSArray <NSArray *>*responseObj, NSError *error) {
            complete([DanMuModelArr2Dic dicWithObj:responseObj source:acfun], error);
        }];
    }
    return nil;
}

/**
 *  获取b站弹幕
 *
 *  @param parameters 参数
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getBiliBiliDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://bangumi.bilibili.com/jsonp/avseason/46431.ver
    //http://www.bilibilijj.com/Api/AvToCid/3203638
    return [self getWithPath:[NSString stringWithFormat: @"http://www.bilibilijj.com/Api/AvToCid/%@", parameters[@"aid"]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([BiliBiliVideoInfoModel yy_modelWithDictionary: responseObj], error);
    }];
}

/**
 *  获取a站弹幕
 *
 *  @param parameters 参数
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getAcfunDanMuWithParameters:(NSDictionary *)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://www.acfun.tv/bangumi/video/page?bangumiId=1470358&order=2
    //http://api.aixifan.com/bangumis/1470315 请求头deviceType = 1
    return [self getWithPath:[NSString stringWithFormat:@"http://api.aixifan.com/bangumis/%@", parameters[@"aid"]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([AcfunVideoInfoModel yy_modelWithDictionary: responseObj[@"data"]], error);
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
    return [self getWithPath:[@"http://acplay.net/api/v1/related/" stringByAppendingString: parameters[@"id"]] parameters:nil completionHandler:^(NSDictionary *responseObj, NSError *error) {
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
@end
