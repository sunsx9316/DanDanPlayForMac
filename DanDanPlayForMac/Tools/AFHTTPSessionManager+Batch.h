//
//  AFHTTPSessionManager+Batch.h
//  AF
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (Batch)
+ (void)batchGETWithPaths:(NSArray <NSString *>*)paths
            progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
          completionBlock:(void(^)(NSArray *responseObjects, NSArray <NSURLSessionTask *>*tasks))completionBlock;
@end
