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
    if (!parameters[@"anime"]){
        complete(nil, nil);
        return nil;
    }
    NSString *formatterAnima = [parameters[@"anime"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString* basePath = @"http://acplay.net/api/v1/searchall/";
    //episode属性不存在
    if (!parameters[@"episode"]) {
        basePath = [basePath stringByAppendingFormat:@"%@",formatterAnima];
    }else{
        basePath = [basePath stringByAppendingFormat:@"%@/%@",formatterAnima,[parameters[@"episode"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    }
    
    return [self getWithPath:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([SearchModel yy_modelWithDictionary:responseObj], error);
    }];
}
@end
