//
//  DanDanPlayMessageModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanDanPlayMessageModel.h"

@implementation DanDanPlayMessageModel

- (instancetype)initWithMessage:(NSString *)message infomationMessage:(NSString *)infomationMessage {
    if (self = [super init]) {
        _message = message;
        _infomationMessage = infomationMessage;
    }
    return self;
}

- (instancetype)initWithType:(DanDanPlayMessageType)type {
    NSDictionary *tempDic = [self shareAlertMessageDic][[NSString stringWithFormat:@"%ld", type]];
    return [[DanDanPlayMessageModel alloc] initWithMessage:tempDic[@"message"] infomationMessage:tempDic[@"infomationMessage"]];
}

+ (instancetype)messageModelWithType:(DanDanPlayMessageType)type {
    return [[DanDanPlayMessageModel alloc] initWithType:type];
}

#pragma mark - 私有方法
- (NSDictionary *)shareAlertMessageDic {
    static dispatch_once_t onceToken;
    static NSDictionary *dic = nil;
    dispatch_once(&onceToken, ^{
        dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"alert_message" ofType:@"plist"]];
    });
    return dic;
}
@end
