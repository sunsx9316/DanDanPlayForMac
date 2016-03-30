//
//  ThirdPartyDanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartyDanMuChooseViewModel.h"
#import "DanMuNetManager.h"

@implementation ThirdPartyDanMuChooseViewModel
- (NSInteger)episodeCount{
    return self.videos.count;
}
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return index < self.videos.count?self.videos[index].title:@"";
}

- (NSString *)danmakuWithIndex:(NSInteger)index{
    return index < self.videos.count?self.videos[index].danmaku:@"";
}

- (void)refreshCompletionHandler:(void(^)(NSError *error))complete{
    
}

- (void)downThirdPartyDanMuWithDanmakuID:(NSString *)danmakuID provider:(NSString *)provider completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!danmakuID || [danmakuID isEqualToString: @""]){
        complete(nil, kNoMatchError);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmaku":danmakuID, @"provider":provider} completionHandler:^(id responseObj, NSError *error) {
        if (![responseObj count]) {
            error = kNoMatchError;
        }
        complete(responseObj, error);
    }];
}

- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj, NSError *error))complete{
    
}

- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
}
@end
