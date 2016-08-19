//
//  DanDanPlayError.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanDanPlayErrorModel.h"

@implementation DanDanPlayErrorModel
+ (instancetype)ErrorWithCode:(DanDanPlayErrorType)errorCode {
    NSString *errorMessage;
    
    switch (errorCode) {
        case DanDanPlayErrorTypeNilObject:
            errorMessage = @"对象为空";
            break;
        case DanDanPlayErrorTypeNoMatchDanmaku:
            errorMessage = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
            break;
        case DanDanPlayErrorTypeVersionNoExist:
            errorMessage = @"版本不存在";
            break;
        case DanDanPlayErrorTypeEpisodeNoExist:
            errorMessage = @"分集不存在";
            break;
        case DanDanPlayErrorTypeDanmakuNoExist:
            errorMessage = @"弹幕不存在";
            break;
        case DanDanPlayErrorTypeVideoNoExist:
            errorMessage = @"视频不存在";
            break;
        default:
            errorMessage = @"未知错误";
            break;
    }
    
    DanDanPlayErrorModel *error = [[DanDanPlayErrorModel alloc] initWithDomain:errorMessage code:errorCode userInfo:nil];
    return error;
}

+ (instancetype)ErrorWithError:(NSError *)error {
    if (!error) return nil;
    
    DanDanPlayErrorModel *model = [[DanDanPlayErrorModel alloc] initWithDomain:error.domain code:error.code userInfo:error.userInfo];
    return model;
}

@end
