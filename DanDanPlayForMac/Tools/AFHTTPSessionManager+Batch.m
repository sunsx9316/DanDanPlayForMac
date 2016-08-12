//
//  AFHTTPSessionManager+Batch.m
//  AF
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "AFHTTPSessionManager+Batch.h"

@implementation AFHTTPSessionManager (Batch)
+ (void)batchGETWithPaths:(NSArray <NSString *>*)paths
            progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
          completionBlock:(void(^)(NSArray *responseObjects, NSArray <NSURLSessionTask *>*tasks))completionBlock {
    
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableArray *responseObjectArr = [NSMutableArray array];
    NSMutableArray *taskArr = [NSMutableArray array];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    
    for (NSInteger i = 0; i < paths.count ; ++i) {
        [responseObjectArr addObject:[NSNull null]];
        [taskArr addObject:[NSNull null]];
        
        NSString *path = paths[i];
        dispatch_group_enter(group);
        
        NSURLSessionDataTask *dataTask = [manager GET:path parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            @synchronized (responseObjectArr) {
                if (responseObject) {
                    responseObjectArr[i] = responseObject;
                }
            }
            @synchronized (taskArr) {
                if (task) {
                    taskArr[i] = task;
                }
            }
            
            if (progressBlock) {
                progressBlock(i, paths.count);
            }
            dispatch_group_leave(group);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            if (progressBlock) {
                progressBlock(i, paths.count);
            }
            @synchronized (taskArr) {
                if (operation) {
                    taskArr[i] = operation;
                }
            }
            
            dispatch_group_leave(group);
        }];
        [dataTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completionBlock) {
            completionBlock(responseObjectArr, taskArr);
        }
    });
}
@end
