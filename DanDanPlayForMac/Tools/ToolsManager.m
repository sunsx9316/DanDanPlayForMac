//
//  ToolsManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ToolsManager.h"
#import <IOKit/pwr_mgt/IOPMLib.h>

@implementation ToolsManager
{
    IOPMAssertionID _assertionID;
}
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

+ (NSString *)appName {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
}

+ (float)appVersion {
    return [[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] floatValue];
}

+ (instancetype)shareToolsManager {
    static dispatch_once_t onceToken;
    static ToolsManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ToolsManager alloc] init];
    });
    return manager;
}

- (void)disableSleep {
    CFStringRef reasonForActivity= CFSTR("Describe Activity Type");
    IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep, kIOPMAssertionLevelOn, reasonForActivity, &_assertionID);
}

- (void)ableSleep {
    IOPMAssertionRelease(_assertionID);
}

#pragma mark - 懒加载
- (NSMutableSet <NSURLSessionDownloadTask *> *)downLoadTaskSet {
    if(_downLoadTaskSet == nil) {
        _downLoadTaskSet = [[NSMutableSet <NSURLSessionDownloadTask *> alloc] init];
    }
    return _downLoadTaskSet;
}

@end
