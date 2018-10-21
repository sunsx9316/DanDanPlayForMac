//
//  DDPMethod.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 2018/10/21.
//  Copyright © 2018 JimHuang. All rights reserved.
//

#import "DDPMethod.h"

@implementation DDPMethod

+ (NSString *)apiDomain {
    return @"https://api.acplay.net/";
}

+ (NSString *)apiPath {
    return [[self apiDomain] stringByAppendingString:@"api/v1"];
}

+ (NSString *)apiNewPath {
    return [[self apiDomain] stringByAppendingString:@"/api/v2"];
}

NSColor *DDPRGBColor(int r, int g, int b) {
    return DDPRGBAColor(r, g, b, 1);
}

NSColor *DDPRGBAColor(int r, int g, int b, CGFloat a) {
    return [NSColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

@end
