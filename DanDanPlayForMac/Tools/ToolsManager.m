//
//  ToolsManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ToolsManager.h"

@implementation ToolsManager
+ (NSString *)stringValueWithDanmakuSource:(DanDanPlayDanmakuSource)source {
    switch (source) {
        case DanDanPlayDanmakuSourceAcfun:
            return @"acfun";
        case DanDanPlayDanmakuSourceBilibili:
            return @"bilibili";
        case DanDanPlayDanmakuSourceOfficial:
            return @"official";
        default:
            break;
    }
    return @"";
}

+ (DanDanPlayDanmakuSource)enumValueWithDanmakuSourceStringValue:(NSString *)source {
    if ([source isEqualToString: @"acfun"]) {
        return DanDanPlayDanmakuSourceAcfun;
    }
    else if ([source isEqualToString: @"bilibili"]) {
        return DanDanPlayDanmakuSourceBilibili;
    }
    else if ([source isEqualToString: @"official"]) {
        return DanDanPlayDanmakuSourceOfficial;
    }
    return DanDanPlayDanmakuSourceUnknow;
}

+ (NSMutableArray *)userSentDanmaukuArrWithEpisodeId:(NSString *)episodeId {
    return [NSMutableArray arrayWithArray: [NSKeyedUnarchiver unarchiveObjectWithFile: [self userDanmakuCachePathWithEpisodeId: episodeId]]];
}

+ (void)saveUserSentDanmakus:(NSArray *)sentDanmakus episodeId:(NSString *)episodeId {
    if (sentDanmakus == nil || episodeId.length == 0) return;
    
    [NSKeyedArchiver archiveRootObject:sentDanmakus toFile:[self userDanmakuCachePathWithEpisodeId: episodeId]];
}

#pragma mark - 私有方法
+ (NSString *)userDanmakuCachePathWithEpisodeId:(NSString *)episodeId {
    NSString *path = [ToolsManager stringValueWithDanmakuSource:DanDanPlayDanmakuSourceOfficial];
    return [[UserDefaultManager shareUserDefaultManager].danmakuCachePath stringByAppendingPathComponent:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_user", episodeId]]];
}
@end
