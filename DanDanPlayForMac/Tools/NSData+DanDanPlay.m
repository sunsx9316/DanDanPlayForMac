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
    return [[NSString stringWithFormat:@"\"%@\"", [[self aes256EncryptWithKey:[NSData dataWithBase64EncodedString:kDanDanPlayKey] iv:[NSData dataWithBase64EncodedString:kDanDanPlayIV]] base64EncodedString]] dataUsingEncoding:NSUTF8StringEncoding];
}
@end
