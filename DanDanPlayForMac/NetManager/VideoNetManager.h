//
//  VideoNetManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface VideoNetManager : BaseNetManager
+ (void)bilibiliVideoURLWithDanmaku:(NSString *)danmaku completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
+ (void)downloadVideoWithURL:(NSURL *)URL progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(void(^)(NSURL *downLoadURL, DanDanPlayErrorModel *error))complete;
@end
