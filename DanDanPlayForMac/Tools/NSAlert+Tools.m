//
//  NSAlert+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSAlert+Tools.h"

@implementation NSAlert (Tools)
+ (instancetype)alertWithMessageText:(NSString *)messageText informativeText:(NSString *)informativeText{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = messageText ? messageText : @"";
    alert.informativeText = informativeText ? informativeText : @"";
    return alert;
}
@end
