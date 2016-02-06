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

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj))complete{
    NSString *danMuKuID = [self danMuKuWithIndex: index];
    if (!danMuKuID){
        complete(nil);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmuku":danMuKuID, @"provider":@"acfun"} completionHandler:^(id responseObj, NSError *error) {
        complete(responseObj);
    }];
}

@end
