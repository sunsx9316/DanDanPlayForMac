//
//  VideoNetManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"
#import "VideoPlayURLModel.h"

@interface VideoNetManager : BaseNetManager
+ (id)bilibiliVideoURLWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
