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
@end
