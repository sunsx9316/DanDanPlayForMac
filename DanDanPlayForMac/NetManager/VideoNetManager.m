//
//  VideoNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoNetManager.h"
#import "NSDictionary+Bilibili.h"
#import "StreamingVideoModel.h"

@implementation VideoNetManager
+ (void)bilibiliVideoURLWithDanmaku:(NSString *)danmaku completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete {
    //http://interface.bilibili.com/playurl?cid=6450647&quality=3&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f
    if (!danmaku.length) {
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNilObject]);
        return;
    }
    //存放视频路径的字典
    NSMutableDictionary *videoPathDic = [NSMutableDictionary dictionary];
    //存放参数的字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithDictionary:@{@"cid":danmaku, @"quality":@"2", @"otype": @"json", @"appkey": BILIBILI_APPKEY, @"type": @"hdmp4"}];
    
    //良心画质
    NSString *goodQualityPath = [parametersDic requestPathWithBasePath:@"http://interface.bilibili.com/playurl?"];
    //渣画质
    parametersDic[@"quality"] = @"1";
    parametersDic[@"type"] = @"mp4";
    NSString *badQualityPath = [parametersDic requestPathWithBasePath:@"http://interface.bilibili.com/playurl?"];
    
    [self batchGETWithPaths:@[goodQualityPath, badQualityPath] progressBlock:nil completionBlock:^(NSArray *responseObjects, NSArray<NSURLSessionTask *> *tasks) {
        videoPathDic[@(StreamingVideoQualityHigh)] = [self bilibiliURLsWithResponseObj:responseObjects.firstObject];
        if (responseObjects.count > 0) {
            videoPathDic[@(StreamingVideoQualityLow)] = [self bilibiliURLsWithResponseObj:responseObjects[1]];
        }
        complete(videoPathDic, nil);
    }];
}

+ (void)downloadVideoWithURL:(NSURL *)URL progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(void(^)(NSURL *downLoadURL, DanDanPlayErrorModel *error))complete {
    if (URL == nil || [URL isFileURL]) {
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeVideoNoExist]);
        return;
    }
    
    [self downloadTaskWithPath:URL.absoluteString progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *downloadPath = [UserDefaultManager shareUserDefaultManager].danmakuCachePath;
        //自动下载路径不存在 则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:[downloadPath stringByAppendingPathComponent:@"video"] isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return [NSURL fileURLWithPath: [downloadPath stringByAppendingPathComponent:[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error) {
        complete(filePath, error);
    }];
}

#pragma mark - 私有方法
/**
 *  根据对象获取所有播放地址
 *
 *  @param responseObj 对象
 *
 *  @return 播放地址数组
 */
+ (NSArray *)bilibiliURLsWithResponseObj:(NSDictionary *)responseObj {
    
    NSMutableArray *URLArr = [NSMutableArray array];
    NSDictionary *URLs = [responseObj[@"durl"] firstObject];
    NSString *firstURL = URLs[@"url"];
    //不能播放 flv 的视频 去除
    if (firstURL.length && ![firstURL containsString:@".flv?"]) {
        [URLArr addObject:[NSURL URLWithString:firstURL]];
    }
    
    for (NSString *url in URLs[@"backup_url"]) {
        if (url.length && ![url containsString:@".flv?"]) {
            [URLArr addObject:[NSURL URLWithString:url]];
        }
    }
    return URLArr;
}
@end
