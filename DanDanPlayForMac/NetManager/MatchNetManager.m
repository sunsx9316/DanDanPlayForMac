//
//  MatchNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MatchNetManager.h"
#import "MatchModel.h"

@implementation MatchNetManager
+ (NSURLSessionDataTask *)GETWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(MatchModel *responseObj, DanDanPlayErrorModel *error))complete {
    if (!parameters) {
        complete(nil, [DanDanPlayErrorModel ErrorWithCode:DanDanPlayErrorTypeNilObject]);
        return nil;
    }
    
    return [self GETWithPath:@"http://acplay.net/api/v1/match" parameters:parameters completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
        complete([MatchModel yy_modelWithDictionary: responseObj], error);
    }];
}
@end
