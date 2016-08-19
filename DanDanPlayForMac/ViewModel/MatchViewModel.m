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
@property (nonatomic, strong) LocalVideoModel* videoModel;
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

- (NSString *)videoName{
    return self.videoModel.fileName;
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

- (void)refreshWithModelCompletionHandler:(void(^)(DanDanPlayErrorModel *error, MatchDataModel *dataModel))complete {
    if (!self.videoModel.md5 || !self.videoModel.length || !self.videoModel.fileName){
        complete(nil, nil);
        return;
    }
    
    [MatchNetManager GETWithParameters:@{@"fileName":self.videoModel.fileName, @"hash": self.videoModel.md5, @"length": self.videoModel.length} completionHandler:^(MatchModel *responseObj, DanDanPlayErrorModel *error) {
        //精确匹配
        if (responseObj.matches.count == 1) {
            complete(error, responseObj.matches.firstObject);
            return;
        }
        //没有找到
        if (responseObj.matches.count == 0){
            MatchDataModel *model = [[MatchDataModel alloc] init];
            model.animeTitle = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
            model.episodeTitle = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeCanSearchByUser].message;
            responseObj.matches = @[model];
        }
        
        self.models = responseObj.matches;
        complete(error, nil);
    }];
}

#pragma mark - 私有方法
- (MatchDataModel *)modelWithIndex: (NSInteger)index{
    return index >= [self modelCount] ? nil : self.models[index];
}

@end
