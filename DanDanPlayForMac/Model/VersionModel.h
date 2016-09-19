//
//  VersionModel.h
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseModel.h"

@interface VersionModel : BaseModel
/**
 *  版本
 */
@property (copy, nonatomic) NSString *version;
/**
 *  升级详情
 */
@property (copy, nonatomic) NSString *details;
/**
 *  版本的哈希值
 */
@property (copy, nonatomic) NSString *md5;
/**
 *  版本补丁名
 */
@property (copy, nonatomic) NSString *patch;
@end
