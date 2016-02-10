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

- (void)refreshCompletionHandler:(void(^)(NSError *error))complete{
    if (!self.aid) {
        complete(nil);
        return;
    }
    
    [DanMuNetManager getBiliBiliDanMuWithParameters:@{@"aid":self.aid} completionHandler:^(BiliBiliVideoInfoModel *responseObj, NSError *error) {
        self.videos = responseObj.videos;
        complete(error);
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSString *danmakuID = [self danmakuWithIndex: index];
    if (!danmakuID || [danmakuID isEqualToString: @""]){
        complete(nil, kNoMatchError);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmaku":danmakuID, @"provider":@"bilibili"} completionHandler:^(id responseObj, NSError *error) {
        if (![responseObj count]) {
            error = kNoMatchError;
        }
        complete(responseObj, error);
    }];
}
@end
