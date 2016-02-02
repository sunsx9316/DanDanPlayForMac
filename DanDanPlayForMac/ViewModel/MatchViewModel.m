//
//  MatchViewModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MatchViewModel.h"
#import "MatchModel.h"
#import "LocalVideoModel.h"
#import "MatchNetManager.h"
@interface MatchViewModel()
/**
 *  匹配结果模型
 */
@property (nonatomic, strong) NSArray<MatchDataModel*>* models;
@end

@implementation MatchViewModel
- (NSString *)modelEpisodeIdWithIndex:(NSInteger)index{
    return [self modelWithIndex: index].episodeId;
}

- (NSString *)modelAnimeTitleIdWithIndex:(NSInteger)index{
    return [self modelWithIndex: index].animeTitle;
}

- (NSString *)modelEpisodeTitleWithIndex:(NSInteger)index{
    return [self modelWithIndex: index].episodeTitle;
}

- (NSURL *)modelPathWithIndex:(NSInteger)index{
    return [NSURL fileURLWithPath: self.videoModel.filePath];
}

- (NSInteger)modelCount{
    return self.models.count;
}

- (instancetype)initWithModel: (LocalVideoModel *)model{
    if (self = [super init]) {
        self.videoModel = model;
    }
    return self;
}

- (void)refreshWithModelCompletionHandler:(void(^)(NSError *error))complete{
    [MatchNetManager getWithParameters:@{@"fileName":self.videoModel.fileName, @"hash": self.videoModel.md5, @"length": self.videoModel.length} completionHandler:^(MatchModel *responseObj, NSError *error) {
        self.models = responseObj.matches;
        complete(error);
    }];
}

#pragma mark - 私有方法
- (MatchDataModel *)modelWithIndex: (NSInteger)index{
    return index >= [self modelCount] ? nil : self.models[index];
}

@end
