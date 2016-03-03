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
@class DanMuDataModel, LocalVideoModel, VLCMedia;
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
 *  节目id
 */
@property (strong, nonatomic) NSString *episodeId;
/**
 *  根据下标获取本地视频名称
 *
 *  @param index 下标
 *
 *  @return 名称
 */
- (NSString *)localeVideoNameWithIndex:(NSInteger)index;
/**
 *  获取视频总数
 *
 *  @return 总数
 */
- (NSInteger)localeVideoCount;
/**
 *  是否显示播放图标
 *
 *  @param index 下标
 *
 *  @return 是否显示播放图标
 */
- (BOOL)showPlayIconWithIndex:(NSInteger)index;
/**
 *  获取当前LocalVideoModel
 *
 *  @return LocalVideoModel
 */
- (LocalVideoModel *)currentLocalVideoModel;
/**
 *  当前视频名称
 *
 *  @return 视频名称
 */
- (NSString *)currentVideoName;
/**
 *  添加本地视频
 *
 *  @param videosModel 数组
 */
- (void)addLocalVideosModel:(NSArray *)videosModel;

/**
 *  获取当前VLCMedia
 *
 *  @param complete 回调
 */
- (void)currentVLCMediaWithCompletionHandler:(void(^)(VLCMedia *responseObj))complete;
/**
 *  初始化
 *
 *  @param localVideoModel 本地视频模型
 *  @param arr             弹幕数组
 *  @param episodeId       分集id
 *  @return self
 */
- (instancetype)initWithLocalVideoModels:(NSArray *)localVideoModels danMuDic:(NSDictionary *)dic episodeId:(NSString *)episodeId;
@end
