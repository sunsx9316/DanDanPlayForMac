//
//  NSDictionary+Bilibili.m
//  as
//
//  Created by JimHuang on 16/8/18.
//  Copyright © 2016年 jim. All rights reserved.
//

#import "NSDictionary+Bilibili.h"
#import "NSString+Tools.h"

@implementation NSDictionary (Bilibili)
- (NSString *)requestPathWithBasePath:(NSString *)path {
    NSMutableString *parameter = [[NSMutableString alloc] init];
    //排序后的keys
    NSArray* keys = [self allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        NSComparisonResult re = [obj1 compare: obj2];
        return re == NSOrderedDescending;
    }];
    
    [keys enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parameter appendFormat:@"%@=%@&",obj,self[obj]];
    }];
    NSString *sign = [[parameter substringToIndex:parameter.length - 1] stringByAppendingString:BILIBILI_SECRETKEY];
    return [NSString stringWithFormat:@"%@%@sign=%@", path, parameter, [sign md5String]];
}
@end
