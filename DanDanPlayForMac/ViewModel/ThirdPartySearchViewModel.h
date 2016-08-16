//
//  ThirdPartySearchViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class VideoInfoDataModel;
/**
 *  该类用于继承
 */
@interface ThirdPartySearchViewModel : BaseViewModel
/**
 *  番剧总数
 *
 *  @return 总数
 */
- (NSInteger)shiBanArrCount;
/**
 *  番剧分集数
 *
 *  @return 分集数
 */
- (NSInteger)infoArrCount;
/**
 *  番剧标题
 *
 *  @param row 行数
 *
 *  @return 标题
 */
- (NSString *)shiBanTitleForRow:(NSInteger)row;
/**
 *  分集标题
 *
 *  @param row 行数
 *
 *  @return 标题
 */
- (NSString *)episodeTitleForRow:(NSInteger)row;
/**
 *  番剧id
 *
 *  @param row 行数
 *
 *  @return 番剧id
 */
- (NSString *)seasonIDForRow:(NSInteger)row;
/**
 *  当前选中番剧封面
 *
 *  @return 封面url
 */
- (NSURL *)coverImg;
/**
 *  当前选中番剧标题
 *
 *  @return 标题
 */
- (NSString *)shiBanTitle;
/**
 *  当前选中番剧简介
 *
 *  @return 简介
 */
- (NSString *)shiBanDetail;
/**
 *  当前行是否为番剧
 *
 *  @param row 行数
 *
 *  @return 是否为番剧
 */
- (BOOL)isShiBanForRow:(NSInteger)row;
/**
 *  当前行分集aid
 *
 *  @param row 当前行
 *
 *  @return 分集aid
 */
- (NSString *)aidForRow:(NSInteger)row;
/**
 *  获取当前行图标
 *
 *  @param row 当前行
 *
 *  @return 图标
 */
- (NSImage *)imageForRow:(NSInteger)row;
/**
 *  获取视频分集信息
 *
 *  @return 数组
 */
- (NSArray <VideoInfoDataModel *>*)videoInfoDataModels;
/**
 *  根据关键词刷新 左视图
 *
 *  @param keyWord  关键词
 *  @param complete 回调
 */

- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(DanDanPlayErrorModel *error))complete;
/**
 *  根据SeasonID刷新 右视图
 *
 *  @param SeasonID SeasonID
 *  @param complete 回调
 */
- (void)refreshWithSeasonID:(NSString*)SeasonID completionHandler:(void(^)(DanDanPlayErrorModel *error))complete;
/**
 *  根据行数下载弹幕
 *
 *  @param row      行数
 *  @param complete 回调
 */
- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;

/**
 *  下载第三方弹幕完整方法
 *
 *  @param danmakuID 弹幕库id
 *  @param provider  提供者
 *  @param complete  回调
 */
- (void)downThirdPartyDanMuWithDanmakuID:(NSString *)danmakuID provider:(DanDanPlayDanmakuSource)provider completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete;
@end
