//
//  ShiBanModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DDPBase.h"

#pragma mark - bilibili番剧模型

@interface BiliBiliShiBanModel : DDPBase
/**
 *  标题
 */
@property (strong, nonatomic) NSString *title;
/**
 *  封面
 */
@property (strong, nonatomic) NSURL *cover;
/**
 *  简介
 */
@property (strong, nonatomic) NSString *detail;
/**
 *  分集
 */
@property (strong, nonatomic) NSArray *episodes;
@end

@interface BiliBiliShiBanDataModel : DDPBase
@property (copy, nonatomic) NSString *aid;
/**
 *  分集标题
 */
@property (strong, nonatomic) NSString *title;
@end

#pragma mark - acfun番剧模型

@interface AcFunShiBanModel : DDPBase
@property (strong, nonatomic) NSArray *list;
@end

@interface AcFunShiBanDataModel : DDPBase
/**
 *  分集弹幕库id
 */
@property (strong, nonatomic) NSString *danmakuId;
/**
 *  标题
 */
@property (strong, nonatomic) NSString *title;
@end
