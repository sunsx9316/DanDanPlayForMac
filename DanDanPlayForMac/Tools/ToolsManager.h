//
//  ToolsManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface ToolsManager : NSObject
+ (NSString *)stringValueWithDanmakuSource:(DanDanPlayDanmakuSource)source;
+ (DanDanPlayDanmakuSource)enumValueWithDanmakuSourceStringValue:(NSString *)source;
/**
 *  获取b站视频av号 分集
 *
 *  @param path       路径
 *  @param completion 回调
 */
+ (void)bilibiliAidWithPath:(NSString *)path complectionHandler:(void(^)(NSString *aid, NSString *page))completion;
/**
 *  获取a站av号 分集
 *
 *  @param path url
 *
 *  @return av号 分集
 */
+ (void)acfunAidWithPath:(NSString *)path complectionHandler:(void(^)(NSString *aid, NSString *index))completion;
+ (instancetype)shareToolsManager;
- (void)disableSleep;
- (void)ableSleep;
@end
