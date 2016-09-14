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

+ (NSURLSessionDownloadTask *)downLatestVersionWithVersion:(NSString *)version progress:(void (^)(NSProgress *downloadProgress))progress completionHandler:(void(^)(NSURL *filePath, DanDanPlayErrorModel *error))complete {
    if (!version.length){
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeVersionNoExist]);
        return nil;
    }
    //http://dandanmac.b0.upaiyun.com/dandanplay_1.1.dmg
    
    NSString *path = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/dandanplay_%@.dmg", version];
    
    NSURLSessionDownloadTask *task = [self downloadTaskWithPath:path progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *downloadPath = [UserDefaultManager shareUserDefaultManager].autoDownLoadPath;
        //自动下载路径不存在 则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return [NSURL fileURLWithPath: [downloadPath stringByAppendingPathComponent:[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, DanDanPlayErrorModel *error) {
        complete(filePath, error);
    }];
    return task;
}
@end
