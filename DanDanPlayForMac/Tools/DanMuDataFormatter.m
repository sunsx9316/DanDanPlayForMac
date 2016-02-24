//
//  DanMuDataFormatter.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuDataFormatter.h"
#import "DanMuModel.h"
#import "NSString+Tools.h"

typedef void(^callBackBlock)(DanMuDataModel *model);
@implementation DanMuDataFormatter
+ (NSDictionary *)dicWithObj:(id)obj source:(JHDanMuSource)source{
    NSMutableDictionary <NSNumber *,NSMutableArray <DanMuDataModel *> *> *dic = [NSMutableDictionary dictionary];
    [self switchParseWithSource:source obj:obj block:^(DanMuDataModel *model) {
        if (!dic[@(model.time)]) dic[@(model.time)] = [NSMutableArray array];
        [dic[@(model.time)] addObject: model];
    }];
    return dic;
}

+ (NSArray *)arrWithObj:(id)obj source:(JHDanMuSource)source{
    NSMutableArray *arr = [NSMutableArray array];
    [self switchParseWithSource:source obj:obj block:^(DanMuDataModel *model) {
        [arr addObject: model];
    }];
    return arr;
}

#pragma mark - 私有方法
+ (void)switchParseWithSource:(JHDanMuSource)source obj:(id)obj block:(callBackBlock)block{
    switch (source) {
        case JHDanMuSourceBilibili:
            [self danMuWithBilibiliData:obj block:block];
            break;
        case JHDanMuSourceAcfun:
            [self danMuWithAcfunArr:obj block:block];
            break;
        case JHDanMuSourceOfficial:
            [self danMuWithOfficialArr:obj block:block];
            break;
        default:
            break;
    }
}



//a站解析方式
+ (void)danMuWithAcfunArr:(NSArray *)arr block:(callBackBlock)block{
    for (NSArray *arr2 in arr) {
        for (NSDictionary *dic in arr2) {
            NSString *str = dic[@"c"];
            NSArray *tempArr = [str componentsSeparatedByString:@","];
            if (tempArr.count == 0) continue;
            
            DanMuDataModel *model = [DanMuDataModel new];
            model.time = [tempArr[0] floatValue];
            model.color = [tempArr[1] intValue];
            model.mode = [tempArr[2] intValue];
            model.message = dic[@"m"];
            model.filter = [self filterWithDanMudataModel:model];
            if (block) block(model);
        }
    }
}

//官方解析方式
+ (void)danMuWithOfficialArr:(NSArray<DanMuDataModel *> *)arr block:(callBackBlock)block{
    [arr enumerateObjectsUsingBlock:^(DanMuDataModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.filter = [self filterWithDanMudataModel:model];
        if (block) block(model);
    }];
}

//b站解析方式
+ (void)danMuWithBilibiliData:(NSData*)data block:(callBackBlock)block{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"<d.*>" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    //所有弹幕标签
    for (NSTextCheckingResult* re in resultArr) {
        NSString* subStr = [str substringWithRange:re.range];
        
        NSArray* strArr = [[self getParameterWithString:subStr] componentsSeparatedByString:@","];
        DanMuDataModel* model = [[DanMuDataModel alloc] init];
        model.time = [strArr[0] floatValue];
        model.mode = [strArr[1] intValue];
        model.color = [strArr[3] intValue];
        model.message = [self getTextWithString:subStr];
        model.filter = [self filterWithDanMudataModel:model];
        if (block) block(model);
    }
}

//获取参数
+ (NSString*)getParameterWithString:(NSString*)str{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"\".*\"" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (resultArr.count > 0) {
        return [str substringWithRange:NSMakeRange(resultArr.firstObject.range.location + 1, resultArr.firstObject.range.length - 2)];
    }
    return nil;
}

// 获取内容
+ (NSString*)getTextWithString:(NSString*)str{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@">.*<" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (resultArr.count > 0) {
        return [str substringWithRange:NSMakeRange(resultArr.firstObject.range.location + 1, resultArr.firstObject.range.length - 2)];
    }
    return nil;
}

//过滤弹幕
+ (BOOL)filterWithDanMudataModel:(DanMuDataModel *)model{
    NSArray *userFilterArr = [UserDefaultManager userFilter];
    for (NSDictionary *filterDic in userFilterArr) {
        //使用正则表达式
        if ([filterDic[@"state"] intValue] == 1) {
            if ([model.message matchesRegex:filterDic[@"text"] options:NSRegularExpressionCaseInsensitive]) {
                return YES;
            }
        }else if([model.message containsString:filterDic[@"text"]]){
            return YES;
        }
    }
    return NO;
}
@end

