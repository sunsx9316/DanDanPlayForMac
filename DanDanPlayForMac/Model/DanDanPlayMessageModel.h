//
//  DanDanPlayMessageModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  提示文本模型
 */
@interface DanDanPlayMessageModel : NSObject
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) NSString *infomationMessage;
- (instancetype)initWithMessage:(NSString *)message infomationMessage:(NSString *)infomationMessage;
@end
