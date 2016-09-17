//
//  StreamingVideoModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSUInteger, streamingVideoQuality) {
    streamingVideoQualityHigh,
    streamingVideoQualityLow
};

@interface StreamingVideoModel : BaseModel<VideoModelProtocol>
/**
 *  初始化
 *
 *  @param fileURLs       文件所有地址{@"high"@[...], @"low":@[...]}
 *  @param fileName       文件名
 *  @param danmaku        弹幕id
 *  @param danmakuSource  弹幕来源
 *
 *  @return self
 */
- (instancetype)initWithFileURLs:(NSDictionary *)fileURLs fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(DanDanPlayDanmakuSource)danmakuSource;

//- (instancetype)initWithFileURL:(NSURL *)fileURL UNAVAILABLE_ATTRIBUTE;
/**
 *  视频清晰度 设置清晰度 当前url会不同
 */
@property (assign, nonatomic) streamingVideoQuality quality;
/**
 *  视频地址下标
 */
@property (assign, nonatomic) NSInteger URLIndex;

/**
 *  所有地址数 
 *
 *  @return 备用路径数
 */
- (NSInteger)URLsCountWithQuality:(streamingVideoQuality)quality;
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
- (DanDanPlayDanmakuSource)danmakuSource;
@end
