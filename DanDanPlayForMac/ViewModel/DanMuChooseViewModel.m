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
- (NSString *)danMuKuWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] danMuKu];
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
    [DanMuNetManager getWithParameters:@{@"id": self.videoID} completionHandler:^(id responseObj, NSError *error){
        if ([responseObj isKindOfClass: [NSDictionary class]]) {
            self.contentDic = responseObj;
            self.providerArr = [responseObj allKeys];
            self.shiBanArr = responseObj[self.providerArr.firstObject];
            self.episodeTitleArr = self.shiBanArr.firstObject.videos;
        }else{
            NSLog(@"有官方弹幕");
        }
        complete(error);
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj))complete{
    NSString *provider = [self providerNameWithIndex: index];
    NSString *danMuKuID = [self danMuKuWithIndex: index];
    if (!danMuKuID || !provider) return;
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmuku":danMuKuID, @"provider":provider} completionHandler:^(id responseObj, NSError *error) {
        if (!error) complete(responseObj);
    }];
}

- (instancetype)initWithVideoID:(NSString *)videoID{
    if (self = [super init]) {
        self.videoID = videoID;
    }
    return self;
}
@end
