//
//  ThirdPartyDanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartyDanMuChooseViewModel.h"
#import "DanMuNetManager.h"

@implementation ThirdPartyDanMuChooseViewModel
- (NSInteger)episodeCount{
    return self.videos.count;
}
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return index < self.videos.count?self.videos[index].title:@"";
}

- (NSString *)danmakuWithIndex:(NSInteger)index{
    return index < self.videos.count?self.videos[index].danmaku:@"";
}

- (void)refreshCompletionHandler:(void(^)(NSError *error))complete{
    
}

- (void)downThirdPartyDanMuWithDanmakuID:(NSString *)danmakuID provider:(NSString *)provider completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!danmakuID || [danmakuID isEqualToString: @""]){
        complete(nil, kNoMatchError);
        return;
    }
    
    id danMuCache = [self danMuCacheWithDanmakuID:danmakuID provider:provider];
    if (danMuCache) {
        complete(danMuCache, nil);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmaku":danmakuID, @"provider":provider} completionHandler:^(id responseObj, NSError *error) {
        if (![responseObj count]) {
            error = kNoMatchError;
        }else{
            //将弹幕写入缓存
            [self writeDanMuCacheWithProvider:provider danmakuID:danmakuID responseObj:responseObj];
        }
        complete(responseObj, error);
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, NSError *error))complete{
    
}

- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSKeyedArchiver archiveRootObject:responseObj toFile:[cachePath stringByAppendingPathComponent:danmakuID]];
    });
}
@end
