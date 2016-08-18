//
//  AcFunSearchViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AcFunSearchViewModel.h"
#import "DanmakuNetManager.h"
#import "SearchNetManager.h"
#import "SearchModel.h"
#import "ShiBanModel.h"
#import "VideoInfoModel.h"

@implementation AcFunSearchViewModel
{
    //包含普通视频和剧集
    NSArray *_listArr;
    NSArray <AcFunShiBanDataModel *>*_infoArr;
    NSURL *_coverURL;
    NSString *_shiBanTitle;
    NSString *_shiBanDetail;
}

- (NSInteger)shiBanArrCount{
    return _listArr.count;
}
- (NSInteger)infoArrCount{
    return _infoArr.count;
}
- (NSString *)shiBanTitleForRow:(NSInteger)row{
    if (row >= _listArr.count) return @"";
    return [self isShiBanForRow: row]?[NSString stringWithFormat:@"剧集：%@", [_listArr[row] title]]:[_listArr[row] title];
}
- (NSString *)episodeTitleForRow:(NSInteger)row{
    return (row < _infoArr.count)?[NSString stringWithFormat:@"%ld: %@",(long)row + 1, [_infoArr[row] title]]:@"";
}
- (NSString *)seasonIDForRow:(NSInteger)row{
    return (row < _listArr.count)?[_listArr[row] contentId]:@"";
}
- (NSImage *)imageForRow:(NSInteger)row{
    if (row >= _listArr.count) return nil;
    return [self isShiBanForRow: row]?[NSImage imageNamed:NSImageNameStatusAvailable]:nil;
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
- (BOOL)isShiBanForRow:(NSInteger)row{
    return (row < _listArr.count)?[_listArr[row] isBangumi]:NO;
}
- (NSString *)aidForRow:(NSInteger)row{
    return (row < _listArr.count)?[_listArr[row] contentId]:nil;
}

- (NSArray <VideoInfoDataModel *>*)videoInfoDataModels{
    NSMutableArray *arr = [NSMutableArray array];
    [_infoArr enumerateObjectsUsingBlock:^(AcFunShiBanDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VideoInfoDataModel *model = [[VideoInfoDataModel alloc] init];
        model.title = [self episodeTitleForRow: idx];
        model.danmaku = obj.danmakuId;
        [arr addObject: model];
    }];
    return arr;
}

- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(DanDanPlayErrorModel *error))complete {
    if (!keyWord.length) {
        complete([DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNilObject]);
        return;
    }
    
    [SearchNetManager searchAcFunWithParameters:@{@"keyword": keyWord} completionHandler:^(AcFunSearchModel *responseObj, DanDanPlayErrorModel *error) {
        
        //把剧集bangumi属性改为yes
        for (AcFunSearchSpecialModel *model in responseObj.special) {
            model.bangumi = YES;
        }
        //合并剧集和普通视频
        NSMutableArray *arr = [NSMutableArray array];
        if (responseObj.special) {
            [arr addObjectsFromArray:responseObj.special];
        }
        if (responseObj.list) {
            [arr addObjectsFromArray:responseObj.list];
        }
        
        //没有找到
        if (!arr.count) {
            AcFunSearchListModel *listModel = [[AcFunSearchListModel alloc] init];
            listModel.title = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
            [arr addObject:listModel];
            error = [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNilObject];
        }
        
        _listArr = arr;
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
    [SearchNetManager searchAcfunSeasonInfoWithParameters:@{@"seasonID":SeasonID} completionHandler:^(AcFunShiBanModel *responseObj, DanDanPlayErrorModel *error) {
        _infoArr = responseObj.list;
        AcFunSearchSpecialModel *model = nil;
        for (int i = 0; i < _listArr.count; ++i) {
            if ([_listArr[i] isBangumi] && [[_listArr[i] contentId] isEqualToString: SeasonID]) {
                model = _listArr[i];
                break;
            }
        }
        
        _coverURL = [model titleImg];
        _shiBanTitle = [model title]?[model title]:@"";
        _shiBanDetail = [model desc]?[model desc]:@"";
        complete(error);
    }];
}
- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(id responseObj,DanDanPlayErrorModel *error))complete {
    [super downThirdPartyDanmakuWithDanmakuID:[self danmakuIDForRow: row] provider:DanDanPlayDanmakuSourceAcfun completionHandler:complete];
}


#pragma mark - 私有方法

- (NSString *)danmakuIDForRow:(NSInteger)row{
    return (row < _infoArr.count)?_infoArr[row].danmakuId:nil;
}
@end
