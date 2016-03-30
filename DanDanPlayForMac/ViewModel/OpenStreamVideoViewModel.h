//
//  OpenStreamVideoViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoNetManager.h"
@class StreamingVideoModel;
@interface OpenStreamVideoViewModel : BaseViewModel
/**
 *  获取视频总数
 *
 *  @return 视频总数
 */
- (NSInteger)numOfVideos;
/**
 *  获取视频对应下标名称
 *
 *  @param row 下标
 *
 *  @return 名称
 */
- (NSString *)videoNameForRow:(NSInteger)row;
/**
 *  获取视频对应下标弹幕id
 *
 *  @param row 下标
 *
 *  @return 弹幕id
 */
- (NSString *)danmakuForRow:(NSInteger)row;
/**
 *  获取视频url 弹幕
 *
 *  @param row      下标
 *  @param complete 回调
 */
- (void)getVideoURLAndDanmakuForRow:(NSInteger)row completionHandler:(void(^)(StreamingVideoModel *videoModel, NSDictionary *danmakuDic, NSError *error))complete;
/**
 *  刷新
 *
 *  @param complete 回调
 */
- (void)refreshWithcompletionHandler:(void(^)(NSError *error))complete;
/**
 *  初始化
 *
 *  @param aid           视频aid
 *  @param danmakuSource 弹幕来源
 *
 *  @return self
 */
- (instancetype)initWithAid:(NSString *)aid danmakuSource:(NSString *)danmakuSource;
@end
