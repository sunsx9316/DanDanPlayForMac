//
//  AcFunSearchViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AcFunSearchViewModel.h"
#import "DanMuNetManager.h"
#import "SearchNetManager.h"
#import "SearchModel.h"
#import "ShiBanModel.h"

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

- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete{
    if (!keyWord) {
        complete(nil);
        return;
    }
    
    [SearchNetManager searchAcFunWithParameters:@{@"keyword": keyWord} completionHandler:^(AcFunSearchModel *responseObj, NSError *error) {
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
        _listArr = arr;
        _infoArr = nil;
        _coverURL = nil;
        _shiBanTitle = nil;
        _shiBanDetail = nil;
        complete(error);
    }];
}
- (void)refreshWithSeasonID:(NSString*)SeasonID completionHandler:(void(^)(NSError *error))complete{
    if (!SeasonID) {
        complete(nil);
        return;
    }
    [SearchNetManager searchAcfunSeasonInfoWithParameters:@{@"seasonID":SeasonID} completionHandler:^(AcFunShiBanModel *responseObj, NSError *error) {
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
- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(id responseObj,NSError *error))complete{
    [super downThirdPartyDanMuWithDanmakuID:[self danmakuIDForRow: row] provider:@"acfun" completionHandler:complete];
}


#pragma mark - 私有方法

- (NSString *)danmakuIDForRow:(NSInteger)row{
    return (row < _infoArr.count)?_infoArr[row].danmakuId:nil;
}
@end
