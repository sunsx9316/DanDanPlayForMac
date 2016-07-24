//
//  JHSubtitleParser.m
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubtitleParser.h"
#import "JHSubtitle.h"
#import "JHSubtitleHeader.h"
#import "JHColor+Tools.h"

@implementation JHSubtitleParser
+ (NSDictionary *)subtitleDicWithPath:(NSString *)path {
    return [self subtitleDicWithPath:path encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)subtitleDicWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    JHSubtitleParser *parser = [[self alloc] init];
    
    return [parser dicWithContent:[NSString stringWithContentsOfFile:path usedEncoding:&encoding error:nil] fileType:[path pathExtension]];
}

#pragma mark - 私有方法
//将字幕内容转成字典的形式
- (NSDictionary *)dicWithContent:(NSString *)content fileType:(NSString *)fileType {
    if ([fileType localizedCaseInsensitiveContainsString:@"srt"]) {
        return [self parseSRTSubtitle:content];
    }
    else if ([fileType localizedCaseInsensitiveContainsString:@"ass"]) {
        return [self parseASSSubtitle:content];
    }
    return nil;
}

#pragma mark  SRT
//srt字幕解析方式
- (NSDictionary *)parseSRTSubtitle:(NSString *)SRTSubtitle {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *arr = [SRTSubtitle componentsSeparatedByString:@"\r\n"];
    
    NSUInteger count = arr.count;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowColor = [JHColor blackColor];
    shadow.shadowBlurRadius = 3;
    //统一属性字典
    NSDictionary *attDic = @{NSShadowAttributeName : shadow, NSFontAttributeName : [JHFont systemFontOfSize:SUBTITLE_FONT_SIZE], NSForegroundColorAttributeName: [JHColor whiteColor]};
    
    for (NSInteger i = 0; i < count; ++i) {
        NSString *tempStr = arr[i];
        if ([self isPureNumandCharacters:tempStr]) {
            NSString *timeStr = (i + 1) < count ? arr[i + 1] : nil;
            //拼接字幕内容
            NSMutableString *contentStr = [[NSMutableString alloc] init];
            for (NSInteger j = i + 2; j < count; ++j) {
                NSString *tempContentStr = arr[j];
                if ([self isPureNumandCharacters:tempContentStr]) break;
                [contentStr appendFormat:@"%@", tempContentStr];
            }
            
            NSArray *timeArr = [timeStr componentsSeparatedByString:@"-->"];
            
            NSTimeInterval appearTime = [self SRTTimeWithString:timeArr.firstObject];
            NSTimeInterval disappearTime = [self SRTTimeWithString:timeArr.count > 1 ? timeArr[1] : nil];
            
            NSString *appearTimeStr = [NSString stringWithFormat:@"%.1f", appearTime];
            if (!dic[appearTimeStr]) {
                dic[appearTimeStr] = [NSMutableArray array];
            }
            JHSubtitle *sub = [[JHSubtitle alloc] init];
            sub.appearTime = appearTime;
            sub.disappearTime = disappearTime;
            
            sub.attributedString = [[NSAttributedString alloc] initWithString:[self filterBraceWithString:contentStr] attributes:attDic];
            [dic[appearTimeStr] addObject: sub];
        }
    }
    return dic;
}

//srt字幕时间解析方式
- (NSTimeInterval)SRTTimeWithString:(NSString *)SRTTime {
    if (!SRTTime.length) return -1;
    
    NSArray *arr = [SRTTime componentsSeparatedByString:@":"];
    NSTimeInterval hour = [arr.firstObject integerValue] * 3600;
    NSTimeInterval minute = arr.count > 1 ? [arr[1] integerValue] * 60 : 0;
    
    NSArray *secondArr = [arr[2] componentsSeparatedByString:@","];
    NSString *secondStr = arr.count > 1 ? secondArr.firstObject : nil;
    NSString *millisecondStr = arr.count > 1 ? [NSString stringWithFormat:@"0.%@", secondArr[1]] : nil;
    NSTimeInterval second = [secondStr integerValue] + [millisecondStr floatValue] ;
    
    return hour + minute + second;
}

//判断字符串是否为纯数字
- (BOOL)isPureNumandCharacters:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark ASS

- (NSDictionary *)parseASSSubtitle:(NSString *)content {
    NSMutableDictionary *timeDic = [NSMutableDictionary dictionary];
    NSDictionary *formatDic = [self ASSFormatWithContent:content];
    NSArray <NSDictionary *>* subTitlesArr = [self ASSSubtitleWithContent:content];
    NSMutableDictionary *attCacheDic = [NSMutableDictionary dictionary];
    
    //Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
    for (NSDictionary *dic in subTitlesArr) {
        NSTimeInterval startTime = [self ASSTimeWithString:dic[@"Start"]];
        NSTimeInterval endTime = [self ASSTimeWithString:dic[@"End"]];
        
        NSString *startTimeStr = [NSString stringWithFormat:@"%.1f", startTime];
        
        if (!dic[startTimeStr]) {
            timeDic[startTimeStr] = [NSMutableArray array];
        }
        
        JHSubtitle *sub = [[JHSubtitle alloc] init];
        sub.appearTime = startTime;
        sub.disappearTime = endTime;
    //Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
        NSString *style = dic[@"Style"];
        NSDictionary *styDic = nil;
        if (attCacheDic[style]) {
            styDic = attCacheDic[style];
        }
        else if (attCacheDic[[NSString stringWithFormat:@"*%@", style]]) {
            styDic = attCacheDic[[NSString stringWithFormat:@"*%@", style]];
        }
        else {
            styDic = [self attDicWithStyle:style formatDic:formatDic];
            attCacheDic[style] = styDic;
        }
        sub.attributedString = [[NSAttributedString alloc] initWithString:dic[@"Text"] attributes:styDic];
        [timeDic[startTimeStr] addObject:sub];
    }
    return timeDic;
}

/**
 *  获取ass字幕的格式
 *
 *  @param content 字幕内容
 *
 *  @return 字幕格式
 */
- (NSDictionary *)ASSFormatWithContent:(NSString *)content {
    NSMutableDictionary *stylesDic = [NSMutableDictionary dictionary];
    NSArray *formatArr = [self ASSValueArrWithRegularExpression:@"Format:.*" content:content number:0];
    NSDictionary <NSString *, NSArray *>*formatDic = [self ASSStyleValueDicWithContent:content];
    [formatDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.count == formatArr.count) {
            stylesDic[key] = [NSDictionary dictionaryWithObjects:obj forKeys:formatArr];
        }
    }];
    
    return stylesDic;
}

/**
 *  按照正则获取值的数组
 *
 *  @param expression 正则表达式
 *  @param content    内容
 *  @param number     获取第几个结果 因为可能匹配到多个的情况
 *
 *  @return 值的数组
 */
- (NSArray <NSString *>*)ASSValueArrWithRegularExpression:(NSString *)expression  content:(NSString *)content number:(NSUInteger)number {
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    NSArray *valueArr;
    //取出对应下标的结果
    if (number < resultArr.count) {
        NSTextCheckingResult* result = resultArr[number];
        if (result.range.location != NSNotFound) {
            NSString* subStr = [content substringWithRange:result.range];
            NSArray *strArr = [subStr componentsSeparatedByString:@":"];
            if (strArr.count > 0) {
                //去掉空格 顺便分割数组
                NSString *tempStr = [strArr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
                valueArr = [tempStr componentsSeparatedByString:@","];
            }
        }
    }
    return valueArr;
}

/**
 *  获取所有的style属性
 *
 *  @param content 字符串内容
 *
 *  @return style字典
 */
- (NSDictionary <NSString *, NSArray <NSString *>*>*)ASSStyleValueDicWithContent:(NSString *)content {
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"Style:.*" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
    NSString *removeStr = @"Style:";
    for (NSTextCheckingResult *result in resultArr) {
        NSString* subStr = [content substringWithRange:result.range];
        if (removeStr.length <= subStr.length) {
            subStr = [subStr substringFromIndex:removeStr.length];
            //去掉空格 顺便分割数组
            NSString *tempStr = [subStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *tempArr = [tempStr componentsSeparatedByString:@","];
            if (tempArr.count) {
                valueDic[tempArr[0]] = [tempStr componentsSeparatedByString:@","];
            }
        }
    }
    return valueDic;
}

/**
 *  获取内容中的所有字幕
 *
 *  @param content 内容
 *
 *  @return 字幕数组
 */
- (NSArray <NSDictionary *>*)ASSSubtitleWithContent:(NSString *)content {
    //字幕的格式数组
    NSArray *formatArr = [self ASSValueArrWithRegularExpression:@"Format:.*" content:content number:1];
    
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"Dialogue:.*" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableArray *valueArr = [NSMutableArray array];
    NSString *removeStr = @"Dialogue: ";
    for (NSTextCheckingResult *result in resultArr) {
        NSString* subStr = [content substringWithRange:result.range];
        if (removeStr.length <= subStr.length) {
            subStr = [subStr substringFromIndex:removeStr.length];
            NSArray *tempArr = [subStr componentsSeparatedByString:@","];
            if (tempArr.count == formatArr.count) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:tempArr forKeys:formatArr];
                dic[@"Text"] = [self filterBraceWithString:dic[@"Text"]];
                [valueArr addObject:dic];
            }
            //防止内容出现","的情况
            else if (tempArr.count > formatArr.count) {
                NSUInteger count = tempArr.count;
                NSMutableArray *tempArr2 = [NSMutableArray arrayWithArray:[tempArr subarrayWithRange:NSMakeRange(0, formatArr.count)]];
                NSString *lastStr = tempArr[formatArr.count - 1];
                for (NSInteger i = formatArr.count; i < count; ++i) {
                    lastStr = [lastStr stringByAppendingString:tempArr[i]];
                }
                tempArr2[formatArr.count - 1] = lastStr;
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:tempArr2 forKeys:formatArr];
                dic[@"Text"] = [self filterBraceWithString:dic[@"Text"]];
                [valueArr addObject:dic];
            }
        }
    }
    return valueArr;
}

//ASS字幕时间解析方式
- (NSTimeInterval)ASSTimeWithString:(NSString *)SRTTime {
    if (!SRTTime.length) return -1;
    
    NSArray *arr = [SRTTime componentsSeparatedByString:@":"];
    NSTimeInterval hour = [arr.firstObject integerValue] * 3600;
    NSTimeInterval minute = arr.count > 1 ? [arr[1] integerValue] * 60 : 0;
    
    NSArray *secondArr = [arr[2] componentsSeparatedByString:@"."];
    NSString *secondStr = arr.count > 1 ? secondArr.firstObject : nil;
    NSString *millisecondStr = arr.count > 1 ? [NSString stringWithFormat:@"0.%@", secondArr[1]] : nil;
    NSTimeInterval second = [secondStr integerValue] + [millisecondStr floatValue] ;
    
    return hour + minute + second;
}

/**
 *  获取属性字典
 *
 *  @param style     属性名
 *  @param formatDic 风格字典
 *
 *  @return 属性字典
 */
- (NSDictionary *)attDicWithStyle:(NSString *)style formatDic:(NSDictionary *)formatDic {
    NSDictionary *dic = formatDic[style];
    if (!dic && style.length) {
        dic = formatDic[[style substringFromIndex:1]];
    }
    
    CGFloat fontSize = [dic[@"Fontsize"] floatValue];
    JHFont *font = [JHFont fontWithName:dic[@"Fontname"] size:fontSize];
    if (!font) {
        font = [JHFont systemFontOfSize:SUBTITLE_FONT_SIZE];
    }
    JHColor *fontColor = [JHColor colorWithHexString:dic[@"PrimaryColour"]];
    if (!fontColor) {
        fontColor = [JHColor whiteColor];
    }
    JHColor *shadowsColor = [JHColor colorWithHexString:dic[@"OutlineColour"]];
    if (!shadowsColor) {
        shadowsColor = [JHColor blackColor];
    }
    
    NSUInteger BorderStyle = [dic[@"BorderStyle"] integerValue];
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName : font, NSForegroundColorAttributeName: fontColor}];
    
    if (BorderStyle == 1) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowColor = shadowsColor;
        shadow.shadowBlurRadius = 3;
        attDic[NSShadowAttributeName] = shadow;
    }
    return attDic;
}

/**
 *  过滤花括号
 *
 *  @param string 内容
 *
 *  @return 过滤后的字符串
 */
- (NSString *)filterBraceWithString:(NSString *)string {
    NSRange range = [string rangeOfString:@"\\{.*\\}" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return [string substringWithRange:NSMakeRange(range.length, string.length - range.length)];
    }
    return string;
}

@end
