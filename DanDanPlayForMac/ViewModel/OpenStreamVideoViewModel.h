//
//  OpenStreamVideoViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoNetManager.h"
#import "VideoInfoModel.h"

@class StreamingVideoModel;
@interface OpenStreamVideoViewModel : BaseViewModel
@property (strong, nonatomic) NSArray <VideoInfoDataModel *>*models;
/**
 *  获取视频模型 弹幕
 *
 *  @param row      下标
 *  @param complete 回调
 */
- (void)getVideoURLAndDanmakuForRow:(NSInteger)row completionHandler:(void(^)(StreamingVideoModel *videoModel, DanDanPlayErrorModel *error))complete;
/**
 *  获取视频模型 弹幕
 *
 *  @param videoName     视频名称
 *  @param danmaku       弹幕id
 *  @param danmakuSource 弹幕源
 *  @param complete      回调
 */
- (void)getVideoURLAndDanmakuForVideoName:(NSString *)videoName danmaku:(NSString *)danmaku danmakuSource:(DanDanPlayDanmakuSource)danmakuSource completionHandler:(void(^)(StreamingVideoModel *videoModel, DanDanPlayErrorModel *error))complete;
/**
 *  刷新
 *
 *  @param complete 回调
 */
- (void)refreshWithcompletionHandler:(void(^)(DanDanPlayErrorModel *error))complete;
/**
 *  初始化
 *
 *  @param URL           视频URL
 *  @param danmakuSource 弹幕来源
 *
 *  @return self
 */
- (instancetype)initWithURL:(NSString *)URL danmakuSource:(DanDanPlayDanmakuSource )danmakuSource;
@end
