//
//  BaseNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"
#import "AFHTTPDataResponseSerializer.h"

@implementation BaseNetManager
+ (AFHTTPSessionManager *)sharedHTTPSessionManager {
    static AFHTTPSessionManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    });
    return manager;
}

+ (AFHTTPSessionManager *)sharedHTTPSessionDataManager{
    static AFHTTPSessionManager* dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [AFHTTPSessionManager manager];
        dataManager.responseSerializer = [AFHTTPDataResponseSerializer serializer];
        [dataManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    });
    return dataManager;
}

+ (NSURLSessionDataTask *)GETWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete {
    return [[self sharedHTTPSessionManager] GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@", path);
        if (complete) {
            complete(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@", path);
        if (complete) {
            complete(nil, [DanDanPlayErrorModel ErrorWithError:error]);
        }
    }];
}

+ (NSURLSessionDataTask *)GETDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete {
    return [[self sharedHTTPSessionDataManager] GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@", path);
        if (complete) {
            complete(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@", path);
        if (complete) {
            complete(nil, [DanDanPlayErrorModel ErrorWithError:error]);
        }
    }];
}

//+ (NSURLSessionDataTask *)GETDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete {
//    NSError *error;
//    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestBySerializingRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] withParameters:parameters error:&error];
//    
//    return [[self sharedAFDataManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//    }];
//    return [[self _sharedAFDataManager] GET:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", task.response.URL);
//        complete(responseObject, nil);
//    } failure:^(AFHTTPRequestOperation * _Nullable task, NSError * _Nonnull error) {
//        complete(nil, error);
//    }];
//}

+ (NSURLSessionDataTask *)PUTWithPath:(NSString *)path HTTPBody:(NSData *)HTTPBody completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"PUT";
    request.HTTPBody = HTTPBody;
    [request setAllHTTPHeaderFields:@{@"Content-Type":@"application/json"}];
    
    NSURLSessionDataTask *task = [[self sharedHTTPSessionManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"请求%@：%@", error ? @"失败" : @"成功", path);
        complete(responseObject, [DanDanPlayErrorModel ErrorWithError:error]);
    }];
    [task resume];
    return task;
//    AFHTTPRequestOperation *operation = [[self _sharedAFDataManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        complete(responseObject, nil);
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        complete(nil, error);
//    }];
//    [[self _sharedAFDataManager].operationQueue addOperation:operation];
//    return operation;
}


+ (NSURLSessionDownloadTask *)downloadTaskWithPath:(NSString *)path
                                             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error))completionHandler {
    NSURLSessionDownloadTask *task = [[self sharedHTTPSessionManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] progress:downloadProgressBlock destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载%@：%@", error ? @"失败" : @"成功", path);
        completionHandler(response, filePath, [DanDanPlayErrorModel ErrorWithError:error]);
    }];
    [task resume];
    return task;
}

@end
