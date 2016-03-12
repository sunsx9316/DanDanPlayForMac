//
//  UpdateNetManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface UpdateNetManager : BaseNetManager
+ (id)latestVersionWithCompletionHandler:(void(^)(NSString *version, NSString *details, NSString *hash, NSError *error))complete;

+ (id)downLatestVersionWithVersion:(NSString *)version progress:(NSProgress * __autoreleasing *)progress completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
