//
//  BiliBiliDanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BiliBiliDanMuChooseViewModel.h"
#import "DanMuNetManager.h"

@implementation BiliBiliDanMuChooseViewModel

- (void)refreshCompletionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    if (!self.aid) {
        complete(nil);
        return;
    }
    
    [DanMuNetManager GETBiliBiliDanmakuWithAid:self.aid page:1 completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
        self.videos = responseObj.videos;
        complete(error);
    }];
    
//    [DanMuNetManager GETBiliBiliDanMuWithParameters:@{@"aid":self.aid} completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
//    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete{
    [super downThirdPartyDanMuWithDanmakuID:[self danmakuWithIndex: index] provider:DanDanPlayDanmakuSourceBilibili completionHandler:complete];
    
//    [super downThirdPartyDanMuWithDanmakuID:[self danmakuWithIndex: index] provider:bilibili completionHandler:complete];
}


@end
