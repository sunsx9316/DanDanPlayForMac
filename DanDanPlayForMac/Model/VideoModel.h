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
 *  文件名不带格式
 */
- (NSString *)fileName;
/**
 *  文件完整路径
 */
- (NSURL *)filePath;
/**
 *  文件哈希值
 */
- (NSString *)md5;
/**
 *  初始化
 *
 *  @param filePath 文件路径
 *
 *  @return self
 */
- (instancetype)initWithFilePath:(NSString *)filePath;
/**
 *  初始化
 *
 *  @param fileURL 文件路径
 *
 *  @return self
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL;

@end
