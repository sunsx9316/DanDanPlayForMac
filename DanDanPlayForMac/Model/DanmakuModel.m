//
//  DanMuModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DanmakuModel.h"

@implementation DanmakuModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"comments":[DanmakuDataModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"comments":@"Comments"};
}
@end

@implementation DanmakuDataModel
- (LaunchDanmakuModel *)launchDanmakuModel{
    LaunchDanmakuModel *model = [[LaunchDanmakuModel alloc] init];
    model.Time = self.time;
    model.Mode = self.mode;
    model.Color = self.color;
    model.Message = self.message;
    return model;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"time":@"Time", @"mode":@"Mode", @"color":@"Color", @"message":@"Message"};
}
@end

@implementation LaunchDanmakuModel


@end