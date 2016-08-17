//
//  BiliBiliSearchViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BiliBiliSearchViewModel.h"
#import "SearchNetManager.h"
#import "SearchModel.h"
#import "ShiBanModel.h"
#import "DanmakuNetManager.h"
#import "VideoInfoModel.h"

@implementation BiliBiliSearchViewModel
{
    NSArray <BiliBiliSearchDataModel *>*_shiBanViewArr;
    NSArray <BiliBiliShiBanDataModel *>*_infoArr;
    NSURL *_coverURL;
    NSString *_shiBanTitle;
    NSString *_shiBanDetail;
}

- (NSInteger)shiBanArrCount{
    return _shiBanViewArr.count;
}

- (NSInteger)infoArrCount{
    return _infoArr.count;
}

- (NSString *)shiBanTitleForRow:(NSInteger)row{
    if (row >= _shiBanViewArr.count) return @"";
    return [self isShiBanForRow: row]?[NSString stringWithFormat:@"剧集：%@", _shiBanViewArr[row].title]:_shiBanViewArr[row].title;
}

- (NSString *)seasonIDForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].isBangumi? _shiBanViewArr[row].seasonId:_shiBanViewArr[row].aid:@"";
}

- (NSString *)aidForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].aid:nil;
}

- (NSString *)episodeTitleForRow:(NSInteger)row{
    return (row < _infoArr.count)?[NSString stringWithFormat: @"%ld: %@", _infoArr.count - row,_infoArr[row].title]:@"";
}

- (NSImage *)imageForRow:(NSInteger)row{
    if (row >= _shiBanViewArr.count) return nil;
    return [self isShiBanForRow: row]?[NSImage imageNamed:NSImageNameStatusAvailable]:nil;
}

- (BOOL)isShiBanForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].isBangumi:NO;
}

- (NSURL *)coverImg{
    return _coverURL;
}

- (NSString *)shiBanTitle{
    return _shiBanTitle;
}

- (NSString *)shiBanDetail{
    return _shiBanDetail;
}

- (NSArray <VideoInfoDataModel *>*)videoInfoDataModels{
    NSMutableArray *arr = [NSMutableArray array];
    [_infoArr enumerateObjectsUsingBlock:^(BiliBiliShiBanDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VideoInfoDataModel *model = [[VideoInfoDataModel alloc] init];
        model.title = [self episodeTitleForRow: idx];
        model.aid = obj.aid;
        [arr addObject: model];
    }];
    return arr;
}

- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    if (!keyWord.length) {
        complete([DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNilObject]);
        return;
    }
    
    [SearchNetManager searchBiliBiliWithParameters:@{@"keyword": keyWord} completionHandler:^(BiliBiliSearchModel *responseObj, DanDanPlayErrorModel *error) {
        
        //移除掉不是番剧 但是seasonID又不为空的对象
        NSMutableArray *tempArr = [responseObj.result mutableCopy];
        if (!tempArr.count) {
            BiliBiliSearchDataModel *dataModel = [[BiliBiliSearchDataModel alloc] init];
            dataModel.title = [UserDefaultManager alertMessageWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
            tempArr = [NSMutableArray arrayWithObject:dataModel];
            error = [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNilObject];
        }
        else {
            [responseObj.result enumerateObjectsUsingBlock:^(BiliBiliSearchDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.isBangumi && obj.seasonId){
                    [tempArr removeObject: obj];
                }
            }];
        }
        
        _shiBanViewArr = tempArr;
        _infoArr = nil;
        _coverURL = nil;
        _shiBanTitle = nil;
        _shiBanDetail = nil;
        complete(error);
    }];
}

- (void)refreshWithSeasonID:(NSString*)SeasonID completionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    if (!SeasonID) {
        complete(nil);
        return;
    }
    
    [SearchNetManager searchBiliBiliSeasonInfoWithParameters:@{@"seasonID": SeasonID} completionHandler:^(BiliBiliShiBanModel *responseObj, DanDanPlayErrorModel *error) {
        _infoArr = responseObj.episodes;
        _coverURL = responseObj.cover;
        _shiBanTitle = responseObj.title ? responseObj.title : @"";
        _shiBanDetail = responseObj.detail ? responseObj.detail : @"";
        complete(error);
    }];
}

- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(id responseObj,DanDanPlayErrorModel *error))complete {
    [DanmakuNetManager GETBiliBiliDanmakuInfoWithAid:[self episodeAidForRow:row] page:1 completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
        [super downThirdPartyDanMuWithDanmakuID:responseObj.videos.firstObject.danmaku provider:DanDanPlayDanmakuSourceBilibili completionHandler:complete];
    }];
    
//    [DanmakuNetManager GETBiliBiliDanMuWithParameters:@{@"aid": [self episodeAidForRow:row]} completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
//        [super downThirdPartyDanMuWithDanmakuID:responseObj.videos.firstObject.danmaku provider:@"bilibili" completionHandler:complete];
//    }];
}


#pragma mark - 私有方法

//- (NSString *)danmakuIDForRow:(NSInteger)row {
//    return (row < _infoArr.count) ? _infoArr[row].danmaku : nil;
//}

- (NSString *)episodeAidForRow:(NSInteger)row {
    return (row < _infoArr.count) ? _infoArr[row].aid : nil;
}

@end
