//
//  MatchViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
@class LocalVideoModel, MatchDataModel;
@interface MatchViewModel : BaseModel
/**
 *  分集id
 *
 *  @param index 下标
 *
 *  @return 分集id
 */
- (NSString *)modelEpisodeIdWithIndex:(NSInteger)index;
/**
 *  分集标题
 *
 *  @param index 下标
 *
 *  @return 分集标题
 */
- (NSString *)modelAnimeTitleIdWithIndex:(NSInteger)index;
/**
 *  分集类型
 *
 *  @param index 下标
 *
 *  @return 分集类型
 */
- (NSString *)modelEpisodeTitleWithIndex:(NSInteger)index;
/**
 *  视频名称
 *
 *  @return 视频名称
 */
- (NSString *)videoName;
/**
 *  总行数
 *
 *  @return 总行数
 */
- (NSInteger)modelCount;

/**
 *  根据model初始化
 *
 *  @param model 视频模型
 *
 *  @return self
 */
- (instancetype)initWithModel: (LocalVideoModel *)model;
/**
 *  根据模型刷新
 *
 *  @param complete 回调
 */
- (void)refreshWithModelCompletionHandler:(void(^)(NSError *error, MatchDataModel *dataModel))complete;
@end
