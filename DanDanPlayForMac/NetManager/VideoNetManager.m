//
//  VideoNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoNetManager.h"

@implementation VideoNetManager
+ (id)bilibiliVideoURLWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://interface.bilibili.com/playurl?cid=6450647&quality=3&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f
    if (!parameters[@"danmaku"]) {
        complete(nil, kObjNilError);
        return nil;
    }
    
    return [self GETWithPath:[NSString stringWithFormat:@"http://interface.bilibili.com/playurl?cid=%@&quality=3&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f", parameters[@"danmaku"]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([VideoPlayURLModel yy_modelWithDictionary:responseObj], error);
    }];
}
@end
