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

+ (id)latestVersionWithCompletionHandler:(void(^)(NSString *version, NSString *details, NSString *hash,NSError *error))complete{
    return [self GETDataWithPath:@"http://dandanmac.b0.upaiyun.com/version.xml" parameters:nil completionHandler:^(id responseObj, NSError *error) {
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:responseObj error:nil];
        GDataXMLElement *rootElement = document.rootElement;
        NSString *version = [[rootElement elementsForName:@"version"].firstObject stringValue];
        NSString *details = [[rootElement elementsForName:@"details"].firstObject stringValue];
        NSString *hash = [[rootElement elementsForName:@"hash"].firstObject stringValue];
        complete(version, details, hash, error);
    }];
}

+ (id)downLatestVersionWithVersion:(NSString *)version progress:(NSProgress * __autoreleasing *)progress completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://dandanmac.b0.upaiyun.com/dandanplay_1.1.dmg
    if (!version || [version isEqualToString:@""]){
        complete(nil, kObjNilError);
        return nil;
    }
    
    version = [NSString stringWithFormat:@"http://dandanmac.b0.upaiyun.com/dandanplay_%@.dmg", version];
    NSURLSessionTask *task = [[[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:version]] progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath: [[UserDefaultManager autoDownLoadPath] stringByAppendingPathComponent:[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        complete(filePath, error);
    }];
    [task resume];
    return task;
}
@end
