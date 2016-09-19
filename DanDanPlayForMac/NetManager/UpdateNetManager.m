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

+ (NSURLSessionDataTask *)latestVersionWithCompletionHandler:(void(^)(VersionModel *model))complete {
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]] dataTaskWithURL:[NSURL URLWithString:@"http://dandanmac.b0.upaiyun.com/version1.xml"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:data error:nil];
        GDataXMLElement *rootElement = document.rootElement;
        
        VersionModel *model = [[VersionModel alloc] init];
        model.version = [[rootElement elementsForName:@"version"].firstObject stringValue];
        model.details = [[rootElement elementsForName:@"details"].firstObject stringValue];
        model.md5 = [[rootElement elementsForName:@"hash"].firstObject stringValue];
        model.patch = [[rootElement elementsForName:@"patch"].firstObject stringValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(model);
        });
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDownloadTask *)downLatestVersionWithVersion:(NSString *)version progress:(void (^)(NSProgress *downloadProgress))progress completionHandler:(void(^)(NSURL *filePath, DanDanPlayErrorModel *error))complete {
    if (!version.length){
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeVersionNoExist]);
        return nil;
    }
    //http://dandanmac.b0.upaiyun.com/dandanplay_1.1.dmg
    
    NSString *path = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/dandanplay_%@.dmg", version];
    
    __block NSURLSessionDownloadTask *task = [self downloadTaskWithPath:path progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *downloadPath = [UserDefaultManager shareUserDefaultManager].autoDownLoadPath;
        //自动下载路径不存在 则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return [NSURL fileURLWithPath: [downloadPath stringByAppendingPathComponent:[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error) {
        task = nil;
        complete(filePath, error);
    }];
    return task;
}

+ (NSURLSessionDownloadTask *)downPatchWithVersion:(NSString *)version hash:(NSString *)hash completionHandler:(void(^)(NSURL *filePath, DanDanPlayErrorModel *error))complete {
    if (!version.length || !hash.length){
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeVersionNoExist]);
        return nil;
    }
    //http://dandanmac.b0.upaiyun.com/patch/2.0/318a79dcb7dcc17496789e02b9af521f
    
    NSString *path = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/patch/%@/%@", version, hash];
    
    __block NSURLSessionDownloadTask *task = [self downloadTaskWithPath:path progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *downloadPath = [UserDefaultManager shareUserDefaultManager].patchPath;
        //自动下载路径不存在 则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return [NSURL fileURLWithPath:[downloadPath stringByAppendingPathComponent:hash]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error) {
        task = nil;
        complete(filePath, error);
    }];
    return task;

}
@end
