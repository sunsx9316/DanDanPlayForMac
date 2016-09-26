//
//  NSUserNotificationCenter+Tools.m
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSUserNotificationCenter+Tools.h"

@implementation NSUserNotificationCenter (Tools)
+ (void)postMatchMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle informativeText:(NSString *)informativeText delegate:(id<NSUserNotificationCenterDelegate>)delegate {
    //删除已经显示过的通知(已经存在用户的通知列表中的)
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    
    //删除已经在执行的通知(比如那些循环递交的通知)
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]){
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.subtitle = subtitle;
    notification.informativeText = informativeText;
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = delegate;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}


+ (void)postMatchMessageWithMatchName:(NSString *)matchName delegate:(id<NSUserNotificationCenterDelegate>)delegate {
    matchName = matchName.length ? [NSString stringWithFormat:@"视频自动匹配为 %@", matchName] : [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoMatchVideo].message;
    [self postMatchMessageWithTitle:[ToolsManager appName] subtitle:nil informativeText:matchName delegate:delegate];
}
@end
