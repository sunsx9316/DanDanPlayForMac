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

+ (id)latestVersionWithCompletionHandler:(void(^)(NSString *version, NSString *details, NSError *error))complete{
    return [self GETWithPath:@"api.acplay.net:8089/api/v1/update/mac" parameters:nil completionHandler:^(id responseObj, NSError *error) {
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:responseObj error:nil];
        GDataXMLElement *rootElement = document.rootElement;
        NSString *version = [[rootElement elementsForName:@"version"].firstObject stringValue];
        NSString *details = [[rootElement elementsForName:@"details"].firstObject stringValue];
        NSLog(@"%@ %@", version, details);
        complete(version, details, error);
    }];
}

+ (id)downLatestVersionWithVersion:(NSString *)version progress:(NSProgress *)progress completionHandler:(void(^)(id responseObj, NSError *error))complete{
    ////http://dandanmac.b0.upaiyun.com/dandanplay_1.1.dmg
    if (!version || [version isEqualToString:@""]){
        complete(nil, kObjNilError);
        return nil;
    }
    version = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/dandanplay_%@.dmg", version];
    
    NSURLSessionDownloadTask *task =
    [[[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:version]] progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path =  NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES).firstObject;
        if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [NSURL fileURLWithPath: [path stringByAppendingPathComponent:[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        complete(filePath, error);
    }];
    [task resume];
    return task;
}
@end
