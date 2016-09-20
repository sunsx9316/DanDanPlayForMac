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
@property (strong, nonatomic) NSArray <id<VideoModelProtocol>>*videos;
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
 *  流媒体对应类型个数
 *
 *  @param type 类型 (high、low)
 *
 *  @return 个数
 */
//- (NSInteger)openStreamCountWithQuality:(streamingVideoQuality)quality;
///**
// *  流媒体当前播放url下标
// *
// *  @return 播放url下标
// */
//- (NSInteger)openStreamIndex;
///**
// *  流媒体清晰度
// *
// *  @return 流媒体清晰度
// */
//- (streamingVideoQuality)openStreamQuality;
///**
// *  设置流媒体对应下标和清晰度
// *
// *  @param quality 清晰度
// *  @param index   下标
// */
//- (void)setOpenStreamURLWithQuality:(streamingVideoQuality)quality index:(NSInteger)index;
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
@end
