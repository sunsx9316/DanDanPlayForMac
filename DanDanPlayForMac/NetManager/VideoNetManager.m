//
//  VideoNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoNetManager.h"
#import "AFHTTPSessionManager+Batch.h"

@implementation VideoNetManager
+ (void)bilibiliVideoURLWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://interface.bilibili.com/playurl?cid=6450647&quality=3&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f
    if (!parameters[@"danmaku"]) {
        complete(nil, kObjNilError);
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *goodQualityPath = [NSString stringWithFormat:@"http://interface.bilibili.com/playurl?cid=%@&quality=2&otype=json&appkey=86385cdc024c0f6c&type=hdmp4&sign=7fed8a9b7b446de4369936b6c1c40c3f", parameters[@"danmaku"]];
    NSString *badQualityPath = [NSString stringWithFormat:@"http://interface.bilibili.com/playurl?cid=%@&quality=1&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f", parameters[@"danmaku"]];
    
     [AFHTTPSessionManager batchGETWithPaths:@[goodQualityPath, badQualityPath] progressBlock:nil completionBlock:^(NSArray *responseObjects, NSArray<NSURLSessionTask *> *tasks) {
        dic[@"high"] = [self bilibiliURLsWithResponseObj:responseObjects.firstObject];
        dic[@"low"] = [self bilibiliURLsWithResponseObj:responseObjects[1]];
    }];
    
//    NSMutableArray *tasks = [NSMutableArray array];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    //良心画质
//    AFHTTPRequestOperation *op1 = [self GETWithPath:[NSString stringWithFormat:@"http://interface.bilibili.com/playurl?cid=%@&quality=2&otype=json&appkey=86385cdc024c0f6c&type=hdmp4&sign=7fed8a9b7b446de4369936b6c1c40c3f", parameters[@"danmaku"]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
//        dic[@"high"] = [self bilibiliURLsWithResponseObj:responseObj];
//    }];
//    [tasks addObject:op1];
//    
//    //渣画质
//    AFHTTPRequestOperation *op2 = [self GETWithPath:[NSString stringWithFormat:@"http://interface.bilibili.com/playurl?cid=%@&quality=1&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f", parameters[@"danmaku"]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
//        dic[@"low"] = [self bilibiliURLsWithResponseObj:responseObj];
//    }];
//    [tasks addObject:op2];
//    
//    NSArray* operations = [AFURLConnectionOperation batchOfRequestOperations:tasks progressBlock:nil completionBlock:^(NSArray *operations) {
//        complete(dic, nil);
//    }];
//    [[NSOperationQueue mainQueue] addOperations:@[operations.lastObject] waitUntilFinished:NO];
//    return tasks;
}

#pragma mark - 私有方法
/**
 *  根据对象获取所有播放地址
 *
 *  @param responseObj 对象
 *
 *  @return 播放地址数组
 */
+ (NSArray *)bilibiliURLsWithResponseObj:(NSDictionary *)responseObj {

    NSMutableArray *URLArr = [NSMutableArray array];
    NSDictionary *URLs = [responseObj[@"durl"] firstObject];
    NSString *firstURL = URLs[@"url"];
    if (firstURL.length && ![firstURL containsString:@".flv?"]) [URLArr addObject:[NSURL URLWithString:firstURL]];
    
    for (NSString *url in URLs[@"backup_url"]) {
        if (url.length && ![url containsString:@".flv?"]) [URLArr addObject:[NSURL URLWithString:url]];
    }
    return URLArr;
}
@end
