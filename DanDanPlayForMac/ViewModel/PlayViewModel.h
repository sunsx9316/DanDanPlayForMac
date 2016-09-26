//
//  PlayViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "StreamingVideoModel.h"
#import "LocalVideoModel.h"
/**
 *  播放视图模型
 */
@class DanmakuDataModel;

typedef void(^reloadDanmakuCallBack)(CGFloat progress, id<VideoModelProtocol>videoModel, DanDanPlayErrorModel *error);

@interface PlayViewModel : BaseViewModel
/**
 *  视频模型
 */
@property (strong, atomic) NSArray <id<VideoModelProtocol>>*videos;
/**
 *  弹幕总数
 */
@property (assign, nonatomic, readonly) NSUInteger danmakuCount;
/**
 *  当前视频下标
 */
@property (assign, nonatomic) NSUInteger currentIndex;
/**
 *  获取当前VideoModel
 *
 *  @return VideoModel
 */
- (id<VideoModelProtocol>)currentVideoModel;
/**
 *  获取当前视频上次播放时间
 *
 *  @return 时间
 */
- (NSTimeInterval)currentVideoLastVideoTime;

/**
 *  根据下标获取模型
 *
 *  @param index 下标
 *
 *  @return VideoModel
 */
- (id<VideoModelProtocol>)videoModelWithIndex:(NSUInteger)index;
/**
 *  添加视频
 *
 *  @param videosModel 数组
 */
- (void)addVideosModel:(NSArray *)videosModel;
/**
 *  移除视频
 *
 *  @param index 下标
 */
- (void)removeVideoAtIndex:(NSInteger)index;

/**
 *  同步播放列表
 */
- (void)synchronizeVideoList;
/**
 *  保存用户发送弹幕
 *
 *  @param danmakuModel 弹幕模型
 */
- (void)saveUserDanmaku:(DanmakuDataModel *)danmakuModel;
/**
 *  根据下标重新刷新弹幕
 *
 *  @param index 下标
 */
- (void)reloadDanmakuWithIndex:(NSInteger)index completionHandler:(reloadDanmakuCallBack)complete;
/**
 *  下载当前视频
 *
 *  @param downloadProgressBlock 进度回调
 *  @param complete              完成回调
 */
- (void)downloadCurrentVideoWithProgress:(void (^)(id<VideoModelProtocol>model))downloadProgressBlock completionHandler:(void(^)(id<VideoModelProtocol>model, NSURL *downLoadURL, DanDanPlayErrorModel *error))complete;
@end
