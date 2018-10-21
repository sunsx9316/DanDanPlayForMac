//
//  MatchViewModel.m
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MatchViewModel.h"
#import "MatchModel.h"
#import "LocalVideoModel.h"
#import "MatchNetManager.h"

@implementation MatchViewModel
- (void)refreshWithCompletionHandler:(void(^)(DanDanPlayErrorModel *error, MatchDataModel *dataModel))complete {
    
    [MatchNetManager GETWithFileName:_videoModel.fileName hash:_videoModel.md5 length:_videoModel.length completionHandler:^(MatchModel *responseObj, DanDanPlayErrorModel *error) {
        //精确匹配
        if (responseObj.matches.count == 1) {
            complete(error, responseObj.matches.firstObject);
            return;
        }
        //没有找到
        if (responseObj.matches.count == 0){
            MatchDataModel *model = [[MatchDataModel alloc] init];
            model.animeTitle = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
            model.episodeTitle = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeCanSearchByUser].message;
            responseObj.matches = @[model];
        }
        
        self.models = responseObj.matches;
        complete(error, nil);
    }];
}

@end
