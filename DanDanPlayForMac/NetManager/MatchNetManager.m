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
+ (NSURLSessionDataTask *)GETWithFileName:(NSString *)fileName hash:(NSString *)hash length:(NSString *)length completionHandler:(void(^)(MatchModel* responseObj, DanDanPlayErrorModel *error))complete {
    if (!hash.length || !length.length) {
        complete(nil, [DanDanPlayErrorModel errorWithCode:DanDanPlayErrorTypeNilObject]);
        return nil;
    }
    
    if (!fileName.length) {
        fileName = @"";
    }
    
    return [self GETWithPath:@"http://acplay.net/api/v1/match" parameters:@{@"fileName":fileName, @"hash": hash, @"length": length} completionHandler:^(id responseObj, DanDanPlayErrorModel *error) {
        complete([MatchModel yy_modelWithDictionary: responseObj], error);
    }];
}
@end
