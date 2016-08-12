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
#import "NSString+Tools.h"

@implementation SearchNetManager
+ (NSURLSessionDataTask *)GETWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(SearchModel* responseObj, NSError *error))complete{
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
    
    return [self GETWithPath:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([SearchModel yy_modelWithDictionary:responseObj], error);
    }];
}

+ (NSURLSessionDataTask *)searchBiliBiliWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!parameters[@"keyword"]){
        complete(nil, nil);
        return nil;
    }
    
    [self GETWithPath:[@"http://biliproxy.chinacloudsites.cn/search/" stringByAppendingString:[parameters[@"keyword"] stringByURLEncode]] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([BiliBiliSearchModel yy_modelWithDictionary: responseObj], error);
    }];
    return nil;
}

+ (NSURLSessionDataTask *)searchBiliBiliSeasonInfoWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    if (!parameters[@"seasonID"]) {
        complete(nil, nil);
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"http://bangumi.bilibili.com/jsonp/seasoninfo/%@.ver?", parameters[@"seasonID"]];
    
    return [self GETWithPath:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        if ([responseObj isKindOfClass:[NSData class]]) {
            NSString *tempStr = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
            NSRange range = [tempStr rangeOfString:@"\\{.*\\}" options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                tempStr = [tempStr substringWithRange:range];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                dic = dic[@"result"];
                complete([BiliBiliShiBanModel yy_modelWithDictionary: dic], error);
            }
        }
    }];
    
//    return [self GETDataWithPath:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
//        NSString *tempStr = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
//        NSRange range = [tempStr rangeOfString:@"\\{.*\\}" options:NSRegularExpressionSearch];
//        if (range.location != NSNotFound) {
//            tempStr = [tempStr substringWithRange:range];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
//            dic = dic[@"result"];
//            complete([BiliBiliShiBanModel yy_modelWithDictionary: dic], error);
//        }
//    }];
}


+ (NSURLSessionDataTask *)searchAcFunWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://search.acfun.tv/search?cd=1&type=2&sortType=-1&field=title&pageNo=1&pageSize=20&aiCount=3&spCount=3&isWeb=1&q=%E5%90%91%E9%98%B3%E7%B4%A0%E6%8F%8F
    if (!parameters[@"keyword"]) {
        complete(nil, nil);
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"http://search.acfun.tv/search?cd=1&type=2&sortType=-1&field=title&pageNo=1&pageSize=20&aiCount=3&spCount=3&isWeb=1&q=%@", [self encodeKeyWordWithDic:parameters][@"keyword"]];
    
    return [self GETWithPath:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj isKindOfClass:[NSData class]]) {
            NSString *responseObjStr = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
            NSRange range = [responseObjStr rangeOfString:@"\\{.*\\}" options:NSRegularExpressionSearch];
            //a站服务器经常抽风 可能会没找到
            if (!range.length) {
                complete(nil, nil);
                return;
            }
            
            NSDictionary *parseDic = [NSJSONSerialization JSONObjectWithData:[[responseObjStr substringWithRange:range] dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
            
            complete([AcFunSearchModel yy_modelWithDictionary: parseDic[@"data"][@"page"]], error);
        }
        
    }];
    
//    return [self GETDataWithPath:[NSString stringWithFormat:@"http://search.acfun.tv/search?cd=1&type=2&sortType=-1&field=title&pageNo=1&pageSize=20&aiCount=3&spCount=3&isWeb=1&q=%@", [self encodeKeyWordWithDic:parameters][@"keyword"]] parameters:nil completionHandler:^(NSData *responseObj, NSError *error) {
//        NSString *responseObjStr = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
//        
//        NSRange range = [responseObjStr rangeOfString:@"\\{.*\\}" options:NSRegularExpressionSearch];
//        //a站服务器经常抽风 可能会没找到
//        if (!range.length) {
//            complete(nil, nil);
//            return;
//        }
//        
//        NSDictionary *parseDic = [NSJSONSerialization JSONObjectWithData:[[responseObjStr substringWithRange:range] dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
//        
//        complete([AcFunSearchModel yy_modelWithDictionary: parseDic[@"data"][@"page"]], error);
//    }];
}

+ (NSURLSessionDataTask *)searchAcfunSeasonInfoWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://www.acfun.tv/bangumi/video/page?bangumiId=2628&order=2
    NSString *subID = [parameters[@"seasonID"] substringFromIndex: 2];
    if (!subID || !subID.length) {
        complete(nil, nil);
        return nil;
    }
    
    return [self GETWithPath:[NSString stringWithFormat:@"http://www.acfun.tv/bangumi/video/page?bangumiId=%@&order=2", subID] parameters: nil completionHandler:^(id responseObj, NSError *error) {
        if (responseObj[@"data"]) {
            responseObj = responseObj[@"data"];
        }
        
        complete([AcFunShiBanModel yy_modelWithDictionary: responseObj], error);
    }];
}

#pragma mark - 私有方法
/**
 *  对关键词做编码处理
 *
 *  @param aDic 未处理的字典
 *  @param keyWord 关键字key
 *
 *  @return 处理后的字典
 */
+ (NSDictionary *)encodeKeyWordWithDic:(NSDictionary *)aDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary: aDic];
    dic[@"keyword"] =  [dic[@"keyword"] stringByURLEncode];
    return dic;
}
@end
