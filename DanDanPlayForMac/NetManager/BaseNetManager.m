//
//  BaseNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

static AFHTTPRequestOperationManager* manager = nil;
static AFHTTPSessionManager* dataManager = nil;

@implementation BaseNetManager
+ (AFHTTPRequestOperationManager *)_sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    });
    return manager;
}

+ (AFHTTPSessionManager *)_sharedAFDataManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [AFHTTPSessionManager manager];
        dataManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return dataManager;
}

+ (id)getWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    return [[self _sharedAFManager] GET:path parameters: parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        //NSLog(@"%@", operation.response.URL);
        complete(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        complete(nil, error);
    }];
}

+ (id)getDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
   return [[self _sharedAFDataManager] GET:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       //NSLog(@"%@", task.response.URL);
       complete(responseObject, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       complete(nil, error);
   }];
}
@end
