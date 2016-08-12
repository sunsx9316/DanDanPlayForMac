//
//  BaseNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetManager : NSObject
/**
 *  GET封装
 *
 *  @param path       路径
 *  @param parameters 参数
 *  @param complete   完成回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  GET封装 直接获取data
 *
 *  @param path       路径
 *  @param parameters 参数
 *  @param complete   回调
 *
 *  @return 任务
 */
//+ (NSURLSessionDataTask *)GETDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  PUT封装
 *
 *  @param path       路径
 *  @param HTTPBody   HTTPBody 需要发送的数据
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)PUTWithPath:(NSString *)path HTTPBody:(NSData *)HTTPBody completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  下载的封装
 *
 *  @param path                  请求路径
 *  @param downloadProgressBlock 下载回调
 *  @param destination           下载路径
 *  @param completionHandler     完成回调
 *
 *  @return 任务
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithPath:(NSString *)path
                                             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;
@end
