//
//  DanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuChooseViewModel.h"
#import "DanmakuNetManager.h"
#import "VideoInfoModel.h"
#import <DDPCategory/NSArray+DDPTools.h>

@implementation DanMuChooseViewModel
- (NSString *)providerNameWithIndex:(NSInteger)index{
    return [self.providerArr objectOrNilAtIndex: index];
}
- (NSString *)shiBanTitleWithIndex:(NSInteger)index{
    return [[self.shiBanArr objectOrNilAtIndex: index] title];
}
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] title];
}
- (NSString *)danMaKuWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] danmaku];
}

- (NSInteger)providerNum{
    return self.providerArr.count;
}
- (NSInteger)shiBanNum{
    return self.shiBanArr.count;
}
- (NSInteger)episodeNum{
    return self.episodeTitleArr.count;
}



- (void)refreshCompletionHandler:(void (^)(DanDanPlayErrorModel *))complete {
    [DanmakuNetManager GETWithProgramId:_videoId completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
        //对象第一个key不是NSNumber类型说明没有官方弹幕
        if (![[responseObj allKeys].firstObject isKindOfClass:[NSNumber class]]) {
            self.contentDic = responseObj;
            self.providerArr = [responseObj allKeys];
            self.shiBanArr = responseObj[self.providerArr.firstObject];
            self.episodeTitleArr = self.shiBanArr.firstObject.videos;
            complete([DanDanPlayErrorModel errorWithCode:DanDanPlayErrorTypeNoMatchDanmaku]);
        }
        else {
            if (![responseObj count])  {
                error = [DanDanPlayErrorModel errorWithCode:DanDanPlayErrorTypeNoMatchDanmaku];
            }
            id<VideoModelProtocol>vm = [ToolsManager shareToolsManager].currentVideoModel;
            vm.danmakuDic = responseObj;
            if (vm) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAY" object:@[vm]];
            }
            complete(error);
        }
    }];
}

- (void)downThirdPartyDanmakuWithIndex:(NSInteger)index provider:(DanDanPlayDanmakuSource)provider completionHandler:(void(^)(id responseObj))complete{
    NSString *danmakuID = [self danMaKuWithIndex: index];
    if (!danmakuID || !provider){
        complete(nil);
        return;
    }
    
    [DanmakuNetManager downThirdPartyDanmakuWithDanmaku:danmakuID provider:provider completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
        complete(responseObj);
    }];
}
@end
