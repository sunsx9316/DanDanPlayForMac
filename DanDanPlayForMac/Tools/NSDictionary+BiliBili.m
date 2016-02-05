//
//  NSDictionary+BiliBili.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSDictionary+BiliBili.h"
#import "NSDictionary+Tools.h"
#import "NSString+Tools.h"

@implementation NSDictionary (BiliBili)
- (NSString*)sortParameterWithSignWithBasePath:(NSString*)path{
    NSMutableString* parameterString = [[NSMutableString alloc] init];
    NSMutableDictionary * mdic = [[NSMutableDictionary alloc] initWithDictionary: self];
    mdic[@"appkey"] = APPKEY;
    //排序后的keys
    
    NSArray* keysArr = [mdic allKeysSorted];
    
    [keysArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx) [parameterString appendFormat:@"&%@=%@", obj, mdic[obj]];
        else [parameterString appendFormat:@"%@=%@", obj, mdic[obj]];
    }];
    
    return [NSString stringWithFormat: @"%@?%@&sign=%@", path, parameterString, [[parameterString stringByAppendingString: APPSEC] md5String]];
}
@end
