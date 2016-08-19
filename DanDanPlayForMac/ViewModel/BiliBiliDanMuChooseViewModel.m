//
//  BiliBiliDanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BiliBiliDanMuChooseViewModel.h"
#import "DanmakuNetManager.h"

@implementation BiliBiliDanMuChooseViewModel

- (void)refreshCompletionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    if (!self.aid) {
        complete(nil);
        return;
    }
    
    [DanmakuNetManager GETBiliBiliDanmakuInfoWithAid:self.aid page:1 completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
        self.videos = responseObj.videos;
        complete(error);
    }];
    
//    [DanmakuNetManager GETBiliBiliDanMuWithParameters:@{@"aid":self.aid} completionHandler:^(BiliBiliVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
//    }];
}

- (void)downThirdPartyDanmakuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete{
    [super downThirdPartyDanmakuWithDanmakuID:[self danmakuWithIndex: index] provider:DanDanPlayDanmakuSourceBilibili completionHandler:complete];
    
//    [super downThirdPartyDanmakuWithDanmakuID:[self danmakuWithIndex: index] provider:bilibili completionHandler:complete];
}


@end
