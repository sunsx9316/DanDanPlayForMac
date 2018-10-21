//
//  VideoModel.h
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DDPBase.h"
#import "VideoModelProtocol.h"
/**
 *  本地视频模型
 */
@interface LocalVideoModel : DDPBase<VideoModelProtocol>
/**
 *  文件大小
 */
- (NSString *)length;
/**
 *  初始化
 *
 *  @param fileURL 文件路径
 *
 *  @return self
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL;
@end
