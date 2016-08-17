//
//  OpenStreamVideoViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OpenStreamVideoViewModel.h"
#import "DanmakuNetManager.h"
#import "VideoInfoModel.h"
#import "StreamingVideoModel.h"
@interface OpenStreamVideoViewModel()
@property (strong, nonatomic) NSString *aid;
@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) DanDanPlayDanmakuSource danmakuSource;
@property (strong, nonatomic) NSArray <VideoInfoDataModel *>*models;
@end

@implementation OpenStreamVideoViewModel

- (NSInteger)numOfVideos{
    return self.models.count;
}
- (NSString *)videoNameForRow:(NSInteger)row{
    return [self modelForRow:row].title;
}
- (NSString *)danmakuForRow:(NSInteger)row{
    return [self modelForRow:row].danmaku;
}

- (void)getVideoURLAndDanmakuForRow:(NSInteger)row completionHandler:(void(^)(StreamingVideoModel *videoModel, DanDanPlayErrorModel *error))complete{
    [self getVideoURLAndDanmakuForVideoName:[self videoNameForRow:row] danmaku:[self danmakuForRow:row] danmakuSource:self.danmakuSource completionHandler:complete];
}

- (void)getVideoURLAndDanmakuForVideoName:(NSString *)videoName danmaku:(NSString *)danmaku danmakuSource:(DanDanPlayDanmakuSource)danmakuSource completionHandler:(void(^)(StreamingVideoModel *videoModel, DanDanPlayErrorModel *error))complete {
    if (!danmaku.length) danmaku = @"";
    
    if (!videoName.length) videoName = @"";
    
    [VideoNetManager bilibiliVideoURLWithDanmaku:danmaku completionHandler:^(NSDictionary *videosDic, DanDanPlayErrorModel *error) {
        [DanmakuNetManager downThirdPartyDanmakuWithDanmaku:danmaku provider:danmakuSource completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
            StreamingVideoModel *vm = [[StreamingVideoModel alloc] initWithFileURLs:videosDic fileName:videoName danmaku:danmaku danmakuSource:danmakuSource];
            vm.danmakuDic = responseObj;
            vm.quality = [UserDefaultManager defaultQuality];
            complete(vm, error);
        }];
    }];
    
//    [VideoNetManager bilibiliVideoURLWithParameters:@{@"danmaku":danmaku} completionHandler:^(NSDictionary *videosDic, DanDanPlayErrorModel *error) {
//        [DanmakuNetManager downThirdPartyDanMuWithParameters:@{@"provider":danmakuSource, @"danmaku":danmaku} completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
//        }];
//    }];
}

- (void)refreshWithcompletionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    [DanmakuNetManager GETBiliBiliDanmakuInfoWithAid:_aid page:_page completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
        self.models = responseObj.videos;
        complete(error);
    }];
}

- (instancetype)initWithAid:(NSString *)aid danmakuSource:(DanDanPlayDanmakuSource)danmakuSource {
    if (self = [super init]) {
        NSArray *arr = [aid componentsSeparatedByString:@" "];
        self.aid = [arr.firstObject substringFromIndex:2];
        self.page = [arr.lastObject integerValue];
        self.danmakuSource = danmakuSource;
    }
    return self;
}

#pragma mark - 私有方法
- (VideoInfoDataModel *)modelForRow:(NSInteger)row{
    return row < self.models.count ? self.models[row] : nil;
}
@end
