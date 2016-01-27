//
//  DanMuModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DanMuModel.h"

@implementation DanMuModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"comments":[DanMuDataModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"comments":@"Comments"};
}
@end

@implementation DanMuDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"time":@"Time", @"mode":@"Mode", @"color":@"Color", @"message":@"Message"};
}
@end