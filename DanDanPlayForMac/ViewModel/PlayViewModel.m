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
#import "OpenStreamVideoViewModel.h"

#import "MatchModel.h"

#import "DanMuNetManager.h"
#import "VideoNetManager.h"

@interface PlayViewModel()
/**
 *  视频模型
 */
@property (strong, nonatomic) NSMutableArray <VideoModel *>*videos;
@property (strong, nonatomic) NSMutableArray *userDanmaukuArr;
@end

@implementation PlayViewModel

- (NSString *)videoNameWithIndex:(NSInteger)index{
    return [self videoModelWithIndex: index].fileName.length ? [self videoModelWithIndex: index].fileName : @"";
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

- (NSTimeInterval)currentVideoLastVideoTime{
    return [UserDefaultManager videoPlayHistoryWithHash:[self currentVideoModel].md5];
}

- (NSString *)currentVideoHash{
    return [self currentVideoModel].md5;
}

- (NSURL *)currentVideoURL{
    return [self videoURLWithIndex: self.currentIndex];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex > 0 && self.videos.count ? currentIndex % self.videos.count : 0;
}

- (void)addVideosModel:(NSArray *)videosModel{
    [self.videos addObjectsFromArray:videosModel];
    [self synchronizeVideoList];
}

- (void)removeVideoAtIndex:(NSInteger)index{
    if (index == -1) {
        [self.videos removeAllObjects];
    }
    else {
        if (index < self.currentIndex) {
            self.currentIndex--;
        }
        [self.videos removeObjectAtIndex:index];
    }
    [self synchronizeVideoList];
}

- (NSInteger)openStreamCountWithQuality:(streamingVideoQuality)quality{
    StreamingVideoModel *model = (StreamingVideoModel *)[self currentVideoModel];
    return [model URLsCountWithQuality:quality];
}

- (NSInteger)openStreamIndex{
    StreamingVideoModel *model = (StreamingVideoModel *)[self currentVideoModel];
    return model.URLIndex;
}
- (streamingVideoQuality)openStreamQuality{
    StreamingVideoModel *model = (StreamingVideoModel *)[self currentVideoModel];
    return model.quality;
}

- (void)setOpenStreamURLWithQuality:(streamingVideoQuality)quality index:(NSInteger)index{
    StreamingVideoModel *model = (StreamingVideoModel *)[self currentVideoModel];
    model.quality = quality;
    model.URLIndex = index;
}

- (void)synchronizeVideoList {
    [UserDefaultManager setVideoListArr:self.videos];
}

- (void)saveUserDanmaku:(DanMuDataModel *)danmakuModel {
    if (!self.episodeId.length) return;
    [self.userDanmaukuArr addObject:danmakuModel];
    [self saveUserDanmakuCache];
}

- (void)setEpisodeId:(NSString *)episodeId {
    _episodeId = episodeId;
    _userDanmaukuArr = nil;
}

- (void)reloadDanmakuWithIndex:(NSInteger)index completionHandler:(void(^)(CGFloat progress, NSString *videoMatchName, NSError *error))complete{
    VideoModel *videoModel = [self videoModelWithIndex:index];
    if (!videoModel) {
        complete(0, nil, kObjNilError);
        return;
    }
    if ([videoModel isKindOfClass:[LocalVideoModel class]]) {
        LocalVideoModel *vm = (LocalVideoModel *)videoModel;
        if (![[NSFileManager defaultManager] fileExistsAtPath:vm.filePath.path]) {
            complete(0, nil, kObjNilError);
            return;
        }
        
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
                        complete(0, nil, kNoMatchError);
                    }
                }];
            }else{
                //快速匹配失败
                complete(0, nil, kNoMatchError);
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
        
        complete(0.5, nil, nil);
        if (![vm URLsCountWithQuality:streamingVideoQualityHigh] && ![vm URLsCountWithQuality:streamingVideoQualityLow]) {
            //没有请求过的视频
            [[[OpenStreamVideoViewModel alloc] init] getVideoURLAndDanmakuForVideoName:vm.fileName danmaku:vm.danmaku danmakuSource:vm.danmakuSource completionHandler:^(StreamingVideoModel *videoModel, NSError *error) {
                if (index < self.videos.count) {
                    if (videoModel) {
                        vm.danmakuDic = videoModel.danmakuDic;
                        self.videos[index] = vm;
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:nil userInfo:vm.danmakuDic];
                    complete(1, vm.fileName, error);
                }
            }];
        }else{
            if (vm.danmakuDic.count) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:nil userInfo:vm.danmakuDic];
                complete(1, vm.fileName, nil);
            }else{
                [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"provider":danmakuSource, @"danmaku":danmaku} completionHandler:^(id responseObj, NSError *error) {
                    self.currentIndex = index;
                    vm.danmakuDic = responseObj;
                    self.videos[index] = vm;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:nil userInfo:responseObj];
                    complete(1, vm.fileName, error);
                }];
            }
        }
    }
}

- (instancetype)initWithVideoModels:(NSArray *)videoModels danMuDic:(NSDictionary *)dic episodeId:(NSString *)episodeId{
    if (self = [super init]) {
        NSArray *listArr = [UserDefaultManager videoList];
        if (listArr.count) {
            videoModels = [videoModels arrayByAddingObjectsFromArray:listArr];
        }
        self.videos = [videoModels mutableCopy];
        [self synchronizeVideoList];
        self.danmakusDic = dic;
        self.episodeId = episodeId;
    }
    return self;
}

#pragma mark - 私有方法
- (NSURL *)videoURLWithIndex:(NSInteger)index{
    return [self videoModelWithIndex: index].filePath ? [self videoModelWithIndex: index].filePath : nil;
}

- (VideoModel *)videoModelWithIndex:(NSInteger)index{
    return index<self.videos.count ? self.videos[index] : nil;
}


- (NSString *)userDanmakuCachePath {
    return [[UserDefaultManager cachePath] stringByAppendingPathComponent:[official stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_user", self.episodeId]]];
}

- (void)saveUserDanmakuCache {
    [NSKeyedArchiver archiveRootObject:self.userDanmaukuArr toFile:[self userDanmakuCachePath]];
}

#pragma mark - 懒加载
- (NSMutableArray *)userDanmaukuArr {
    if(_userDanmaukuArr == nil) {
        _userDanmaukuArr = [[NSMutableArray alloc] init];
        if (!self.episodeId.length) {
            NSMutableArray *arr = [[NSKeyedUnarchiver unarchiveObjectWithFile: [self userDanmakuCachePath]] mutableCopy];
            if (arr) {
                _userDanmaukuArr = arr;
            }
        }
    }
    return _userDanmaukuArr;
}

@end
