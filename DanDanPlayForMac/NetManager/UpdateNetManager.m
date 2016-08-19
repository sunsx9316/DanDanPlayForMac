//
//  UpdateNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "UpdateNetManager.h"
#import <GDataXMLNode.h>

@implementation UpdateNetManager

+ (NSURLSessionDataTask *)latestVersionWithCompletionHandler:(void(^)(NSString *version, NSString *details, NSString *hash,NSError *error))complete {
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]] dataTaskWithURL:[NSURL URLWithString:@"http://dandanmac.b0.upaiyun.com/version.xml"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:data error:nil];
        GDataXMLElement *rootElement = document.rootElement;
        NSString *version = [[rootElement elementsForName:@"version"].firstObject stringValue];
        NSString *details = [[rootElement elementsForName:@"details"].firstObject stringValue];
        NSString *hash = [[rootElement elementsForName:@"hash"].firstObject stringValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(version, details, hash, error);
        });
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDownloadTask *)downLatestVersionWithVersion:(NSString *)version progress:(void (^)(NSProgress *downloadProgress))progress completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete {
    if (!version.length){
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeVersionNoExist]);
        return nil;
    }
    //http://dandanmac.b0.upaiyun.com/dandanplay_1.1.dmg
    
    NSString *path = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/dandanplay_%@.dmg", version];
    
    NSURLSessionDownloadTask *task = [self downloadTaskWithPath:path progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath: [[UserDefaultManager shareUserDefaultManager].autoDownLoadPath stringByAppendingPathComponent:[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error) {
        complete(filePath, error);
    }];
    
//    version = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/dandanplay_%@.dmg", version];
//    NSURLSessionTask *task = [[[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:version]] progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return [NSURL fileURLWithPath: [[UserDefaultManager autoDownLoadPath] stringByAppendingPathComponent:[response suggestedFilename]]];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        complete(filePath, error);
//    }];
//    [task resume];
    return task;
}
@end
