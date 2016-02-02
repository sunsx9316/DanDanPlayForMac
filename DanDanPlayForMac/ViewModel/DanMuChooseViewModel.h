//
//  DanMuChooseViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class VideoInfoModel, VideoInfoDataModel;

@interface DanMuChooseViewModel : BaseViewModel
@property (nonatomic, strong) NSDictionary *contentDic;
@property (nonatomic, strong) NSArray <NSString *>*supplierArr;
@property (nonatomic, strong) NSArray <VideoInfoModel *>*shiBanArr;
@property (nonatomic, strong) NSArray <VideoInfoDataModel *>*episodeTitleArr;

/**
 *  获取提供者名称
 *
 *  @param index 下标
 *
 *  @return 提供者名称
 */
- (NSString *)supplierNameWithIndex:(NSInteger)index;
/**
 *  获取番剧名称
 *
 *  @param index 下标
 *
 *  @return 番剧名称
 */
- (NSString *)shiBanTitleWithIndex:(NSInteger)index;
/**
 *  获取分集名
 *
 *  @param index 下标
 *
 *  @return 分集名
 */
- (NSString *)episodeTitleWithIndex:(NSInteger)index;
/**
 *  获取弹幕id
 *
 *  @param index 下标
 *
 *  @return 弹幕id
 */
- (NSString *)danMuKuWithIndex:(NSInteger)index;
/**
 *  提供者总数
 *
 *  @return 提供者总数
 */
- (NSInteger)supplierNum;
/**
 *  番剧总数
 *
 *  @return 番剧总数
 */
- (NSInteger)shiBanNum;
/**
 *  分集总数
 *
 *  @return 分集总数
 */
- (NSInteger)episodeNum;



- (void)refreshCompletionHandler:(void(^)(NSError *error))complete;
/**
 *  初始化
 *
 *  @param 番剧参数
 *
 *  @return self
 */
- (instancetype)initWithVideoDic:(NSDictionary *)dic;
@end
