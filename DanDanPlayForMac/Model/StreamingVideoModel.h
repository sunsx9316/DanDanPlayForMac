//
//  StreamingVideoModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoModel.h"

@interface StreamingVideoModel : VideoModel
/**
 *  初始化
 *
 *  @param fileURL        文件路径
 *  @param fileName       文件名
 *  @param danmaku        弹幕id
 *  @param danmakuSource  弹幕来源
 *
 *  @return self
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(NSString *)danmakuSource;
/**
 *  弹幕id
 *
 *  @return 弹幕id
 */
- (NSString *)danmaku;
/**
 *  弹幕来源
 *
 *  @return 弹幕来源
 */
- (NSString *)danmakuSource;
@end
