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
/**
 *  app的名字
 */
+ (NSString *)appName;
/**
 *  app的版本
 */
+ (float)appVersion;
/**
 *  禁止系统休眠
 */
- (void)disableSleep;
/**
 *  恢复系统休眠
 */
- (void)ableSleep;
+ (instancetype)shareToolsManager;
@end
