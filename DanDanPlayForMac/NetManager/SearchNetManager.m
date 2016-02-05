//
//  SearchNetManager.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchNetManager.h"
#import "SearchModel.h"
#import "ShiBanModel.h"
#import "NSDictionary+BiliBili.h"
#import "NSString+Tools.h"

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
        basePath = [basePath stringByAppendingFormat:@"%@/%@",formatterAnima,[parameters[@"episode"] stringByURLEncode]];
    }
    
    return [self getWithPath:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([SearchModel yy_modelWithDictionary:responseObj], error);
    }];
}

+ (id)searchBiliBiliWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!parameters[@"keyword"]){
        complete(nil, nil);
        return nil;
    }
    //对关键词做编码处理
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary: parameters];
    dic[@"keyword"] =  [dic[@"keyword"] stringByURLEncode];
    
    return [self getWithPath:[dic sortParameterWithSignWithBasePath:@"http://api.bilibili.cn/search"] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([BiliBiliSearchModel yy_modelWithDictionary: responseObj], error);
    }];
    return nil;
}


+ (id)searchBiliBiliSeasonInfoWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!parameters[@"seasonID"]) {
        complete(nil, nil);
        return nil;
    }
    return [self getWithPath:[NSString stringWithFormat:@"http://bangumi.bilibili.com/jsonp/seasoninfo/%@.ver?", parameters[@"seasonID"]] parameters: nil completionHandler:^(id responseObj, NSError *error) {
        complete([ShiBanModel yy_modelWithDictionary: responseObj].result, error);
    }];
}
@end
