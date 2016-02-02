//
//  EpisodeChooseViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class EpisodesModel;
@interface EpisodeChooseViewModel : BaseViewModel
/**
 *  分集标题
 *
 *  @param index 下标
 *
 *  @return 分集标题
 */
- (NSString *)episodeTitleWithIndex:(NSInteger)index;
/**
 *  分集id
 *
 *  @param index 下标
 *
 *  @return 分集id
 */
- (NSString *)episodeIDWithIndex:(NSInteger)index;
/**
 *  总分集数
 *
 *  @return 总分集数
 */
- (NSInteger )episodeCount;

- (instancetype)initWithEpisodeArr:(NSArray<EpisodesModel*>*)episodes;
@end
