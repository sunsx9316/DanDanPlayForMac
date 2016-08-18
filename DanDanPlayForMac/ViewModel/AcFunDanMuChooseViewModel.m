//
//  AcFunDanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AcFunDanMuChooseViewModel.h"
#import "DanmakuNetManager.h"


@implementation AcFunDanMuChooseViewModel

- (void)refreshCompletionHandler:(void(^)(DanDanPlayErrorModel *error))complete{
    if (!self.aid) {
        complete(nil);
        return;
    }
    
    [DanmakuNetManager GETAcfunDanmakuInfoWithAid:self.aid completionHandler:^(AcfunVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
        self.videos = responseObj.videos;
        complete(error);
    }];
    
//    [DanmakuNetManager GETAcfunDanMuWithParameters:@{@"aid":self.aid} completionHandler:^(AcfunVideoInfoModel *responseObj, DanDanPlayErrorModel *error) {
//    }];
}

- (void)downThirdPartyDanmakuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, DanDanPlayErrorModel *error))complete {
    [super downThirdPartyDanmakuWithDanmakuID:[self danmakuWithIndex: index] provider:DanDanPlayDanmakuSourceAcfun completionHandler:complete];
    
//    [super downThirdPartyDanmakuWithDanmakuID:[self danmakuWithIndex: index] provider:@"acfun" completionHandler:complete];
}

@end
