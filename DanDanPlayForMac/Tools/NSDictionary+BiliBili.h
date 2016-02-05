//
//  NSDictionary+BiliBili.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BiliBili)
/**
 *  从字典获取已经拼好的get请求的字符串加上sign 方法会自动添加appkey
 *
 *  @param path 不带参数的路径 如: www.bilibili.test 不要带上? 参数不能包含type属性
 *
 *  @return 拼好的字符串
 */
- (NSString*)sortParameterWithSignWithBasePath:(NSString*)path;
@end
