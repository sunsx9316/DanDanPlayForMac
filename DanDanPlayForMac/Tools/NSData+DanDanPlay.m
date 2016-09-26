//
//  NSData+DanDanPlay.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSData+DanDanPlay.h"
#import "NSData+Tools.h"

@implementation NSData (DanDanPlay)
- (NSData *)Encrypt{
    NSString *key = DANDANPLAY_KEY;
    NSString *iv = DANDANPLAY_IV;
#ifdef DEBUG
//测试代码 没什么卵用
    if ([key isEqualToString:@""] || [iv isEqualToString:@""]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay/key&iv"];
        NSArray *arr = [[[NSString alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@" "];
        key = arr[0];
        iv = arr[1];
    }
#endif
    return [[NSString stringWithFormat:@"\"%@\"", [[self aes256EncryptWithKey:[NSData dataWithBase64EncodedString:key] iv:[NSData dataWithBase64EncodedString:iv]] base64EncodedString]] dataUsingEncoding:NSUTF8StringEncoding];
}
@end
