//
//  NSUserNotificationCenter+Tools.h
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserNotificationCenter (Tools)
/**
 *  发送匹配名称的自定义通知
 *
 *  @param matchName 匹配名称
 *  @param delegate  代理
 */
+ (void)postMatchMessageWithMatchName:(NSString *)matchName delegate:(id<NSUserNotificationCenterDelegate>)delegate;
/**
 *  发送自定义通知
 *
 *  @param title           标题
 *  @param subtitle        副标题
 *  @param informativeText 附加信息
 *  @param delegate        代理
 */
+ (void)postMatchMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle informativeText:(NSString *)informativeText delegate:(id<NSUserNotificationCenterDelegate>)delegate;
@end
