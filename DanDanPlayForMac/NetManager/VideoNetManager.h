//
//  VideoNetManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface VideoNetManager : BaseNetManager
+ (void)bilibiliVideoURLWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
