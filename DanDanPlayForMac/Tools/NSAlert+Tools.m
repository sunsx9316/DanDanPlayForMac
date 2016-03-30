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
    alert.messageText = messageText.length ? messageText : @"";
    alert.informativeText = informativeText.length ? informativeText : @"";
    return alert;
}
@end
