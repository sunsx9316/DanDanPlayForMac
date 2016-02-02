//
//  EpisodeChooseViewModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "EpisodeChooseViewModel.h"
#import "SearchModel.h"
@interface EpisodeChooseViewModel()
@property (nonatomic, strong) NSArray <EpisodesModel *>*episodes;
@end
@implementation EpisodeChooseViewModel
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return self.episodes[index].title;
}
- (NSString *)episodeIDWithIndex:(NSInteger)index{
    return self.episodes[index].identity;
}
- (NSInteger )episodeCount{
    return self.episodes.count;
}


- (instancetype)initWithEpisodeArr:(NSArray<EpisodesModel*>*)episodes{
    if (self = [super init]) {
        self.episodes = episodes;
    }
    return self;
}
@end
