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
#import "ScrollDanmaku.h"
#import "FloatDanmaku.h"
#import "JHDanmakuEngine+Tools.h"
#import <GDataXMLNode.h>

typedef void(^callBackBlock)(DanMuDataModel *model);
@implementation DanMuDataFormatter
+ (NSMutableDictionary *)dicWithObj:(id)obj source:(DanDanPlayDanmakuSource)source {
    NSMutableDictionary <NSNumber *,NSMutableArray <ParentDanmaku *> *> *dic = [NSMutableDictionary dictionary];
    if (obj) {
        NSFont *font = [UserDefaultManager danMuFont];
        NSInteger danMufontSpecially = [UserDefaultManager danMufontSpecially];
        
        [self switchParseWithSource:source obj:obj block:^(DanMuDataModel *model) {
            NSInteger time = model.time;
            if (!dic[@(time)]) dic[@(time)] = [NSMutableArray array];
            ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:danMufontSpecially fontSize: font.pointSize font:font];
            danmaku.appearTime = model.time;
            danmaku.filter = model.isFilter;
            [dic[@(time)] addObject: danmaku];
        }];
    }
    return dic;
}

+ (NSMutableArray *)arrWithObj:(id)obj source:(DanDanPlayDanmakuSource)source {
    NSMutableArray *arr = [NSMutableArray array];
    if (obj) {
        NSFont *font = [UserDefaultManager danMuFont];
        NSInteger danMufontSpecially = [UserDefaultManager danMufontSpecially];
        
        [self switchParseWithSource:source obj:obj block:^(DanMuDataModel *model) {
            ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:danMufontSpecially fontSize:font.pointSize font:font];
            danmaku.appearTime = model.time;
            danmaku.filter = model.isFilter;
            [arr addObject: danmaku];
        }];
    }
    return arr;
}

#pragma mark - 私有方法
+ (void)switchParseWithSource:(DanDanPlayDanmakuSource)source obj:(id)obj block:(callBackBlock)block{
    switch (source) {
        case DanDanPlayDanmakuSourceBilibili:
            [self danMuWithBilibiliData:obj block:block];
            break;
        case DanDanPlayDanmakuSourceAcfun:
            [self danMuWithAcfunArr:obj block:block];
            break;
        case DanDanPlayDanmakuSourceOfficial:
            [self danMuWithOfficialArr:obj block:block];
            break;
        case DanDanPlayDanmakuSourceCache:
            [self danMuWithOfficialArr:obj block:block];
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
+ (void)danMuWithBilibiliData:(NSData*)data block:(callBackBlock)block {
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:data error:nil];
    GDataXMLElement *rootElement = document.rootElement;
    NSArray *array = [rootElement elementsForName:@"d"];
    for (GDataXMLElement *ele in array) {
            NSArray* strArr = [[[ele attributeForName:@"p"] stringValue] componentsSeparatedByString:@","];
            DanMuDataModel* model = [[DanMuDataModel alloc] init];
            model.time = [strArr[0] floatValue];
            model.mode = [strArr[1] intValue];
            model.color = [strArr[3] intValue];
            model.message = [ele stringValue];
            model.filter = [self filterWithDanMudataModel:model];
            if (block) block(model);
    }
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

