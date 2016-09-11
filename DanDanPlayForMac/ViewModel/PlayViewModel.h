//
//  PlayViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "StreamingVideoModel.h"
/**
 *  播放视图模型
 */
@class DanMuDataModel, VideoModel, StreamingVideoModel;

typedef void(^reloadDanmakuCallBack)(CGFloat progress, NSString *videoMatchName, DanDanPlayErrorModel *error);

@interface PlayViewModel : BaseViewModel
/**
 *  保存弹幕模型的数组
 */
//@property (strong, nonatomic) NSArray *danmakusArr;
/**
 *  保存弹幕模型的字典
 */
@property (strong, nonatomic) NSDictionary *danmakusDic;
/**
 *  弹幕总数
 */
@property (assign, nonatomic, readonly) NSUInteger danmakuCount;
/**
 *  当前视频下标
 */
@property (assign, nonatomic) NSInteger currentIndex;
/**
 *  官方节目id 用于发射弹幕给指定节目
 */
@property (strong, nonatomic) NSString *episodeId;

/**
 *  根据下标获取本地视频名称
 *
 *  @param index 下标
 *
 *  @return 名称
 */
- (NSString *)videoNameWithIndex:(NSInteger)index;
/**
 *  获取视频总数
 *
 *  @return 总数
 */
- (NSInteger)videoCount;
/**
 *  是否显示播放图标
 *
 *  @param index 下标
 *
 *  @return 是否显示播放图标
 */
- (BOOL)showPlayIconWithIndex:(NSInteger)index;
/**
 *  获取当前VideoModel
 *
 *  @return VideoModel
 */
- (VideoModel *)currentVideoModel;
/**
 *  获取当前视频上次播放时间
 *
 *  @return 时间
 */
- (NSTimeInterval)currentVideoLastVideoTime;
/**
 *  获取当前视频hash
 *
 *  @return hash
 */
- (NSString *)currentVideoHash;

/**
 *  根据下标获取模型
 *
 *  @param index 下标
 *
 *  @return VideoModel
 */
- (VideoModel *)videoModelWithIndex:(NSInteger)index;

/**
 *  当前视频URL
 *
 *  @return URL
 */
- (NSURL *)currentVideoURL;
/**
 *  当前视频名称
 *
 *  @return 视频名称
 */
- (NSString *)currentVideoName;
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
- (NSInteger)openStreamCountWithQuality:(streamingVideoQuality)quality;
/**
 *  流媒体当前播放url下标
 *
 *  @return 播放url下标
 */
- (NSInteger)openStreamIndex;
/**
 *  流媒体清晰度
 *
 *  @return 流媒体清晰度
 */
- (streamingVideoQuality)openStreamQuality;
/**
 *  设置流媒体对应下标和清晰度
 *
 *  @param quality 清晰度
 *  @param index   下标
 */
- (void)setOpenStreamURLWithQuality:(streamingVideoQuality)quality index:(NSInteger)index;
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
- (void)saveUserDanmaku:(DanMuDataModel *)danmakuModel;
/**
 *  根据下标重新刷新弹幕
 *
 *  @param index 下标
 */
- (void)reloadDanmakuWithIndex:(NSInteger)index completionHandler:(reloadDanmakuCallBack)complete;
/**
 *  初始化
 *
 *  @param localVideoModel 本地视频模型
 *  @param arr             弹幕数组
 *  @param episodeId       分集id
 *  @return self
 */
- (instancetype)initWithVideoModels:(NSArray *)videoModels danMuDic:(NSDictionary *)dic episodeId:(NSString *)episodeId;
@end
