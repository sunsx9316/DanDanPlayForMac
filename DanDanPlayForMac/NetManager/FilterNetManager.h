//
//  FilterNetManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface FilterNetManager : BaseNetManager
+ (id)filterWithCompletionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
