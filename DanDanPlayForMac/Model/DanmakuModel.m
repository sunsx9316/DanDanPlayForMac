//
//  DanMuModel.m
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DanmakuModel.h"

@implementation DanmakuModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"comments" : [DanmakuDataModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"comments" : @[@"Comments", @"comments"]};
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
    return @{@"time":@"Time", @"mode":@"Mode", @"color":@"Color", @"message":@[@"Message", @"m"]};
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    //"p": "147.32,1,16777215,[BiliBili]d9840c43",
    NSString *p = dic[@"p"];
    
    if ([p isKindOfClass:[NSString class]]) {
        NSMutableDictionary *mDic = [dic mutableCopy];
        NSArray <NSString *>*arr = [p componentsSeparatedByString:@","];
        if (arr.count > 0) {
            mDic[@"Time"] = arr.firstObject;
        }
        
        if (arr.count > 1) {
            mDic[@"Mode"] = arr[1];
        }
        
        if (arr.count > 2) {
            mDic[@"Color"] = arr[2];
        }
        
        if (arr.count > 3) {
            mDic[@"UId"] = arr[3];
        }
        
        return mDic;
    }
    
    return dic;
}
@end

@implementation LaunchDanmakuModel


@end
