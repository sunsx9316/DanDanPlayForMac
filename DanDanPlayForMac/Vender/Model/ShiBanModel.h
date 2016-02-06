//
//  ShiBanModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseModel.h"

#pragma mark - bilibili番剧模型

@interface BiliBiliShiBanModel : BaseModel
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

@interface BiliBiliShiBanDataModel : BaseModel
/**
 *  danmuku 直接给了
 */
@property (strong, nonatomic) NSString *danmuku;
/**
 *  分集标题
 */
@property (strong, nonatomic) NSString *title;
@end

#pragma mark - acfun番剧模型

@interface AcFunShiBanModel : BaseModel
@property (strong, nonatomic) NSArray *list;
@end

@interface AcFunShiBanDataModel : BaseModel
/**
 *  分集弹幕库id
 */
@property (strong, nonatomic) NSString *danmakuId;
/**
 *  标题
 */
@property (strong, nonatomic) NSString *title;
@end
