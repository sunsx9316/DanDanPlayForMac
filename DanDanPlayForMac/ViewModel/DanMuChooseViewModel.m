//
//  DanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuChooseViewModel.h"
#import "DanMuNetManager.h"
#import "VideoInfoModel.h"
#import "NSArray+Tools.h"


@interface DanMuChooseViewModel()
@property (nonatomic, strong) NSString *videoID;
@end

@implementation DanMuChooseViewModel
- (NSString *)providerNameWithIndex:(NSInteger)index{
    return [self.providerArr objectOrNilAtIndex: index];
}
- (NSString *)shiBanTitleWithIndex:(NSInteger)index{
    return [[self.shiBanArr objectOrNilAtIndex: index] title];
}
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] title];
}
- (NSString *)danMaKuWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] danmaku];
}

- (NSInteger)providerNum{
    return self.providerArr.count;
}
- (NSInteger)shiBanNum{
    return self.shiBanArr.count;
}
- (NSInteger)episodeNum{
    return self.episodeTitleArr.count;
}



- (void)refreshCompletionHandler:(void (^)(NSError *))complete{
    id cache = [self danMuCacheWithDanmakuID:self.videoID provider:@"official"];
    if (cache) {
        complete(nil);
        [self postNotificationWithDanMuObj:cache];
    }
    
    
    [DanMuNetManager getWithParameters:@{@"id": self.videoID} completionHandler:^(NSDictionary *responseObj, NSError *error){
        //字典的第一个对象不是NSNumber类型说明没有官方弹幕
        if (![[responseObj allKeys].firstObject isKindOfClass: [NSNumber class]]) {
            self.contentDic = responseObj;
            self.providerArr = [responseObj allKeys];
            self.shiBanArr = responseObj[self.providerArr.firstObject];
            self.episodeTitleArr = self.shiBanArr.firstObject.videos;
            error = [NSError errorWithDomain:@"noDanMu" code:200 userInfo:nil];
            complete(error);
        }else{
            if (!responseObj.count) {
                error = [NSError errorWithDomain:@"noDanMu" code:200 userInfo:nil];
            }
            complete(error);
            //写入缓存
            [self writeDanMuCacheWithProvider:@"official" danmakuID:self.videoID responseObj:responseObj];
            //发通知
            [self postNotificationWithDanMuObj:responseObj];
        }
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index provider:(NSString *)provider completionHandler:(void(^)(id responseObj))complete{
    NSString *danmakuID = [self danMaKuWithIndex: index];
    if (!danmakuID || !provider){
        complete(nil);
        return;
    }
    
    id danMuCache = [self danMuCacheWithDanmakuID:danmakuID provider:provider];
    if (danMuCache) {
        complete(danMuCache);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmaku":danmakuID, @"provider":provider} completionHandler:^(id responseObj, NSError *error) {
        if ([responseObj count]){
            [self writeDanMuCacheWithProvider:provider danmakuID:danmakuID responseObj:responseObj];
        }

        complete(responseObj);
    }];
}

- (instancetype)initWithVideoID:(NSString *)videoID{
    if (self = [super init]) {
        self.videoID = videoID;
    }
    return self;
}

#pragma mark - 私有方法
- (id)danMuCacheWithDanmakuID:(NSString *)danmakuID provider:(NSString *)provider{
    
    NSString *danMuCachePath = [[UserDefaultManager cachePath] stringByAppendingPathComponent:[provider stringByAppendingPathComponent:danmakuID]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile: danMuCachePath];
}

- (void)writeDanMuCacheWithProvider:(NSString *)provider danmakuID:(NSString *)danmakuID responseObj:(id)responseObj{
    //将弹幕写入缓存
    NSString *cachePath = [[UserDefaultManager cachePath] stringByAppendingPathComponent:provider];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:responseObj toFile:[cachePath stringByAppendingPathComponent:danmakuID]];
}

- (void)postNotificationWithDanMuObj:(id)obj{
    //通知关闭列表视图控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:self userInfo:nil];
    //通知开始播放
    [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:self userInfo:obj];
}
@end
