//
//  ThirdPartyDanmakuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartyDanmakuChooseViewModel.h"
#import "DanmakuNetManager.h"

@implementation ThirdPartyDanmakuChooseViewModel
- (NSInteger)episodeCount{
    return self.videos.count;
}
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return index < self.videos.count?self.videos[index].title:@"";
}

- (NSString *)danmakuWithIndex:(NSInteger)index{
    return index < self.videos.count?self.videos[index].danmaku:@"";
}

- (void)refreshCompletionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    
}

- (void)downThirdPartyDanmakuWithDanmakuID:(NSString *)danmakuID provider:(DanDanPlayDanmakuSource)provider completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete{
    if (!danmakuID.length){
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeDanmakuNoExist]);
        return;
    }
    
    [DanmakuNetManager downThirdPartyDanmakuWithDanmaku:danmakuID provider:provider completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
        if (![responseObj count]) {
            error = [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNoMatchDanmaku];
        }
        complete(responseObj, error);
    }];
//    
//    [DanmakuNetManager downThirdPartyDanmakuWithParameters:@{@"danmaku":danmakuID, @"provider":provider} completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
//    }];
}

- (void)downThirdPartyDanmakuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete{
    
}

- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
}
@end
