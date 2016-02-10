//
//  AcFunDanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AcFunDanMuChooseViewModel.h"
#import "DanMuNetManager.h"


@implementation AcFunDanMuChooseViewModel

- (void)refreshCompletionHandler:(void(^)(NSError *error))complete{
    if (!self.aid) {
        complete(nil);
        return;
    }
    
    [DanMuNetManager getAcfunDanMuWithParameters:@{@"aid":self.aid} completionHandler:^(AcfunVideoInfoModel *responseObj, NSError *error) {
        self.videos = responseObj.videos;
        complete(error);
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSString *danMaKuID = [self danmakuWithIndex: index];
    if (!danMaKuID || [danMaKuID isEqualToString: @""]){
        complete(nil, kNoMatchError);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmaku":danMaKuID, @"provider":@"acfun"} completionHandler:^(NSDictionary *responseObj, NSError *error) {
        if (![responseObj count]) {
            error = kNoMatchError;
        }
        complete(responseObj, error);
    }];
}

@end
