//
//  DanDanPlayError.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DanDanPlayErrorType) {
    /**
     *  空对象错误
     */
    DanDanPlayErrorTypeNilObject,
    /**
     *  没有弹幕匹配的错误
     */
    DanDanPlayErrorTypeNoMatchDanmaku,
    /**
     *  版本不存在
     */
    DanDanPlayErrorTypeVersionNoExist,
    /**
     *  分集不存在
     */
    DanDanPlayErrorTypeEpisodeNoExist,
    /**
     *  弹幕不存在
     */
    DanDanPlayErrorTypeDanmakuNoExist,
    /**
     *  视频不存在
     */
    DanDanPlayErrorTypeVideoNoExist
};

#import <Foundation/Foundation.h>
/**
 *  错误模型
 */
@interface DanDanPlayErrorModel : NSError
+ (instancetype)errorWithCode:(DanDanPlayErrorType)errorCode;
+ (instancetype)errorWithError:(NSError *)error;
@end
