//
//  BaseNetManager.h
//  DanDanPlayer
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
+ (NSURLSessionDataTask *)GETWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
/**
 *  GET data 数据的封装
 *
 *  @param path       路径
 *  @param parameters 参数
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;

/**
 *  GET data 数据的封装
 *
 *  @param path        路径
 *  @param parameters  参数
 *  @param headerField headerField
 *  @param completionHandler    回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)GETDataWithPath:(NSString*)path
                               parameters:(NSDictionary*)parameters
                              headerField:(NSDictionary *)headerField
                        completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))completionHandler;
/**
 *  PUT封装
 *
 *  @param path       路径
 *  @param HTTPBody   HTTPBody 需要发送的数据
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)PUTWithPath:(NSString *)path HTTPBody:(NSData *)HTTPBody completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;

/**
 *  断点续传封装
 *
 *  @param resumeData            恢复数据
 *  @param downloadProgressBlock 下载回调
 *  @param destination           下载路径
 *  @param completionHandler     完成回调
 *
 *  @return 任务
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                             destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error))completionHandler;
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
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error))completionHandler;
/**
 *  批量GET任务
 *
 *  @param paths           路径字典
 *  @param progressBlock   进度回调
 *  @param completionBlock 完成回调
 */
+ (void)batchGETWithPaths:(NSArray <NSString *>*)paths
            progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations, id *responseObj))progressBlock
          completionBlock:(void(^)(NSArray *responseObjects, NSArray <NSURLSessionTask *>*tasks))completionBlock;
/**
 *  批量GETData任务
 *
 *  @param paths           路径字典
 *  @param progressBlock   进度回调
 *  @param completionBlock 完成回调
 */
+ (void)batchGETDataWithPaths:(NSArray <NSString *>*)paths
            progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations, id *responseObj))progressBlock
          completionBlock:(void(^)(NSArray *responseObjects, NSArray <NSURLSessionTask *>*tasks))completionBlock;
@end
