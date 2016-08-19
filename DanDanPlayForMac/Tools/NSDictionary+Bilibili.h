//
//  NSDictionary+Bilibili.h
//  as
//
//  Created by JimHuang on 16/8/18.
//  Copyright © 2016年 jim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Bilibili)
/**
 *  按照 b 站请求的格式拼接路径 字典中需要包含 appkey
 *
 *  @param path 基本路径
 *
 *  @return 拼接之后的路径
 */
- (NSString *)requestPathWithBasePath:(NSString *)path;
@end
