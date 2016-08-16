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
@end
