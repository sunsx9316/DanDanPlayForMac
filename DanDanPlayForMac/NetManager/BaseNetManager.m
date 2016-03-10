//
//  BaseNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@implementation BaseNetManager
+ (AFHTTPRequestOperationManager *)_sharedAFManager{
    static AFHTTPRequestOperationManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    });
    return manager;
}

+ (AFHTTPRequestOperationManager *)_sharedAFDataManager{
    static AFHTTPRequestOperationManager* dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [AFHTTPRequestOperationManager manager];
        dataManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return dataManager;
}

+ (id)GETWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    return [[self _sharedAFManager] GET:path parameters: parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
            {
            //NSLog(@"%@", operation.response.URL);
                complete(responseObject, nil);
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                complete(nil, error);
            }];
}

+ (id)GETDataWithPath:(NSString*)path parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    return [[self _sharedAFDataManager] GET:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull task, id  _Nonnull responseObject) {
        //NSLog(@"%@", task.response.URL);
        complete(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nullable task, NSError * _Nonnull error) {
        complete(nil, error);
    }];
}

+ (id)PUTWithPath:(NSString *)path HTTPBody:(NSData *)HTTPBody parameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"PUT";
    request.HTTPBody = HTTPBody;
    [request setAllHTTPHeaderFields:@{@"Content-Type":@"application/json"}];
    AFHTTPRequestOperation *operation = [[self _sharedAFDataManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        complete(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        complete(nil, error);
    }];
    [[self _sharedAFDataManager].operationQueue addOperation:operation];
    return operation;
}
@end
