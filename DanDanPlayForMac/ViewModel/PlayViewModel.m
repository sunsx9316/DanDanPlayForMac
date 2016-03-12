//
//  PlayViewModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "PlayViewModel.h"
#import "LocalVideoModel.h"
#import "StreamingVideoModel.h"
#import "LocalVideoModel.h"
#import "MatchViewModel.h"
#import "DanMuChooseViewModel.h"

#import "JHVLCMedia.h"
#import "DanMuModel.h"
#import "ParentDanmaku.h"
#import "MatchModel.h"

#import "VLCMedia+Tools.h"
#import "JHDanmakuEngine+Tools.h"

#import "DanMuNetManager.h"
#import "VideoNetManager.h"

@interface PlayViewModel()
/**
 *  视频模型
 */
@property (strong, nonatomic) NSArray <VideoModel *>*videos;
@property (strong, nonatomic) NSMutableDictionary <NSNumber *,VLCMedia *>*VLCMedias;
@property (strong, nonatomic) JHVLCMedia *media;
@end

@implementation PlayViewModel
- (NSString *)videoNameWithIndex:(NSInteger)index{
    return [self videoModelWithIndex: index].fileName?[self videoModelWithIndex: index].fileName:@"";
}

- (NSInteger)videoCount{
    return self.videos.count;
}

- (BOOL)showPlayIconWithIndex:(NSInteger)index{
    return index != self.currentIndex;
}

- (NSString *)currentVideoName{
    return [self videoNameWithIndex: self.currentIndex];
}

- (VideoModel *)currentVideoModel{
    return [self videoModelWithIndex: self.currentIndex];
}

- (NSURL *)currentVideoURL{
    return [self videoURLWithIndex: self.currentIndex];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex>0?currentIndex%self.videos.count:0;
}

- (void)addVideosModel:(NSArray *)videosModel{
    self.videos = [self.videos arrayByAddingObjectsFromArray:videosModel];
}


#pragma mark - 私有方法
- (NSURL *)videoURLWithIndex:(NSInteger)index{
    return [self videoModelWithIndex: index].filePath?[self videoModelWithIndex: index].filePath:nil;
}

- (VideoModel *)videoModelWithIndex:(NSInteger)index{
    return index<self.videos.count?self.videos[index]:nil;
}

- (void)reloadDanmakuWithIndex:(NSInteger)index completionHandler:(void(^)(CGFloat progress, NSString *videoMatchName, NSError *error))complete{
    id videoModel = [self videoModelWithIndex:index];
    if ([videoModel isKindOfClass:[LocalVideoModel class]]) {
        LocalVideoModel *vm = (LocalVideoModel *)videoModel;
        
        [[[MatchViewModel alloc] initWithModel:vm] refreshWithModelCompletionHandler:^(NSError *error, MatchDataModel *dataModel) {
            //episodeId存在 说明精确匹配
            if (dataModel.episodeId) {
                complete(0.5, nil, error);
                self.episodeId = dataModel.episodeId;
                //搜索弹幕
                [[[DanMuChooseViewModel alloc] initWithVideoID: dataModel.episodeId] refreshCompletionHandler:^(NSError *error) {
                    //判断官方弹幕是否为空
                    if (!error) {
                        complete(1, [NSString stringWithFormat:@"%@-%@", dataModel.animeTitle, dataModel.episodeTitle], error);
                    }else{
                        //快速匹配失败
                        complete(0, nil, kObjNilError);
                    }
                }];
            }else{
                //快速匹配失败
                complete(0, nil, kObjNilError);
                self.episodeId = nil;
            }
        }];
        
    }else if ([videoModel isKindOfClass:[StreamingVideoModel class]]){
        self.episodeId = nil;
        StreamingVideoModel *vm = (StreamingVideoModel *)videoModel;
        NSString *danmaku = vm.danmaku;
        NSString *danmakuSource = vm.danmakuSource;
        if (!danmaku || !danmakuSource) {
            complete(0, nil, kObjNilError);
            return;
        }
        [VideoNetManager bilibiliVideoURLWithParameters:@{@"danmaku":danmaku} completionHandler:^(VideoPlayURLModel *responseModel, NSError *error) {
            complete(0.5, nil, error);
            [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"provider":danmakuSource, @"danmaku":danmaku} completionHandler:^(id responseObj, NSError *error) {
                self.currentIndex = index;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:nil userInfo:responseObj];
                complete(1, vm.fileName, error);
            }];
        }];
    }

}

- (instancetype)initWithVideoModels:(NSArray *)videoModels danMuDic:(NSDictionary *)dic episodeId:(NSString *)episodeId{
    if (self = [super init]) {
        self.videos = videoModels;
        self.danmakusDic = dic;
        self.episodeId = episodeId;
    }
    return self;
}

#pragma mark - 懒加载

- (NSMutableDictionary <NSNumber *,VLCMedia *> *)VLCMedias {
	if(_VLCMedias == nil) {
		_VLCMedias = [[NSMutableDictionary <NSNumber *,VLCMedia *> alloc] init];
	}
	return _VLCMedias;
}

@end
