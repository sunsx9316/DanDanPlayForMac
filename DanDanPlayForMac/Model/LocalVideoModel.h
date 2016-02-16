//
//  VideoModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
/**
 *  本地视频模型
 */
@interface LocalVideoModel : BaseModel
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
 *  文件大小
 */
- (NSString *)length;
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
