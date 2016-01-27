//
//  SearchNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchNetManager.h"
#import "SearchModel.h"

@implementation SearchNetManager
+ (id)getWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(SearchModel* responseObj, NSError *error))complete{
    if (!parameters[@"anime"]) return nil;
    
    NSString* basePath = @"http://acplay.net/api/v1/searchall/";
    //episode属性不存在
    if (!parameters[@"episode"]) {
        basePath = [basePath stringByAppendingFormat:@"%@",parameters[@"anime"]];
    }else{
        basePath = [basePath stringByAppendingFormat:@"%@/%@",parameters[@"anime"],parameters[@"episode"]];
    }
    
    return [self getWithPath:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([SearchModel yy_modelWithDictionary:responseObj], error);
    }];
}
@end
