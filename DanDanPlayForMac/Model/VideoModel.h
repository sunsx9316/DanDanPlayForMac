//
//  VideoModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseModel.h"

@interface VideoModel : BaseModel
/**
 *  文件完整路径
 */
- (NSURL *)fileURL;
/**
 *  文件哈希值
 */
- (NSString *)md5;
/**
 *  文件名
 *
 */
- (NSString *)fileName;
/**
 *  初始化
 *
 *  @param fileURL 文件路径
 *
 *  @return self
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL;

@end
