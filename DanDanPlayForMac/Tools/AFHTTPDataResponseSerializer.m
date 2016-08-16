//
//  AFHTTPDataResponseSerializer.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AFHTTPDataResponseSerializer.h"

@implementation AFHTTPDataResponseSerializer
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    return data;
}
@end
