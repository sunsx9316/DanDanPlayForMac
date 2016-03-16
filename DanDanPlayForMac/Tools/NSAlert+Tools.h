//
//  NSAlert+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (Tools)
+ (instancetype)alertWithMessageText:(NSString *)messageText informativeText:(NSString *)informativeText;
@end
