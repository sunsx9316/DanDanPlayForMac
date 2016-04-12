//
//  DanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuChooseViewModel.h"
#import "DanMuNetManager.h"
#import "VideoInfoModel.h"
#import "NSArray+Tools.h"


@interface DanMuChooseViewModel()
@property (nonatomic, strong) NSString *videoID;
@end

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



- (void)refreshCompletionHandler:(void (^)(NSError *))complete{
    [DanMuNetManager GETWithParameters:@{@"id": self.videoID} completionHandler:^(NSDictionary *responseObj, NSError *error){
        //对象第一个key不是NSNumber类型说明没有官方弹幕
        if (![[responseObj allKeys].firstObject isKindOfClass:[NSNumber class]]) {
            self.contentDic = responseObj;
            self.providerArr = [responseObj allKeys];
            self.shiBanArr = responseObj[self.providerArr.firstObject];
            self.episodeTitleArr = self.shiBanArr.firstObject.videos;
            error = [NSError errorWithDomain:@"noDanMu" code:200 userInfo:nil];
            complete(error);
        }else{
            if (![responseObj count]) {
                error = [NSError errorWithDomain:@"noDanMu" code:200 userInfo:nil];
            }
            complete(error);
            //发通知
            [self postNotificationWithDanMuObj:responseObj];
        }
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index provider:(NSString *)provider completionHandler:(void(^)(id responseObj))complete{
    NSString *danmakuID = [self danMaKuWithIndex: index];
    if (!danmakuID || !provider){
        complete(nil);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmaku":danmakuID, @"provider":provider} completionHandler:^(id responseObj, NSError *error) {
        complete(responseObj);
    }];
}

- (instancetype)initWithVideoID:(NSString *)videoID{
    if (self = [super init]) {
        self.videoID = videoID;
    }
    return self;
}

#pragma mark - 私有方法

- (void)postNotificationWithDanMuObj:(id)obj{
    //通知关闭列表视图控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DISSMISS_VIEW_CONTROLLER" object:self userInfo:nil];
    //通知开始播放
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:self userInfo: obj];
}
@end
