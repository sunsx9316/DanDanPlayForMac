//
//  PlayViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
/**
 *  播放视图模型
 */
@class DanMuDataModel, VideoModel;
@interface PlayViewModel : BaseViewModel
/**
 *  保存弹幕模型的数组
 */
@property (strong, nonatomic) NSArray *danmakusArr;
/**
 *  保存弹幕模型的字典
 */
@property (strong, nonatomic) NSDictionary *danmakusDic;

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
 *  根据下标重新刷新弹幕
 *
 *  @param index 下标
 */
- (void)reloadDanmakuWithIndex:(NSInteger)index completionHandler:(void(^)(CGFloat progress, NSString *videoMatchName, NSError *error))complete;
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
