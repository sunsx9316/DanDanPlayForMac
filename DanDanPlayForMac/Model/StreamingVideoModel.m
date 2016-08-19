//
//  StreamingVideoModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "StreamingVideoModel.h"
#import "NSString+Tools.h"

@interface StreamingVideoModel ()
@property (assign, nonatomic) DanDanPlayDanmakuSource danmakuSource;
@property (copy, nonatomic) NSString *danmaku;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *md5;
@property (strong, nonatomic) NSDictionary <NSString *, NSArray <NSURL *>*>*URLs;
@end

@implementation StreamingVideoModel
{
    NSDictionary *_danmakuDic;
    NSString *_danmakuSourceStringValue;
}

- (instancetype)initWithFileURLs:(NSDictionary *)fileURLs fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(DanDanPlayDanmakuSource)danmakuSource {
    if (self = [super init]) {
        _URLs = fileURLs;
        _fileName = fileName;
        _danmaku = danmaku;
        _danmakuSource = danmakuSource;
        _danmakuSourceStringValue = [ToolsManager stringValueWithDanmakuSource:_danmakuSource];
    }
    return self;
}

- (streamingVideoQuality)quality {
    if (_quality == streamingVideoQualityHigh && ![_URLs[@"high"] count]) {
        _quality = streamingVideoQualityLow;
    }
    return _quality;
}

- (NSInteger)URLsCountWithQuality:(streamingVideoQuality)quality {
    NSArray *arr = quality == streamingVideoQualityLow ? _URLs[@"low"] : _URLs[@"high"];
    return arr.count;
}

- (void)setDanmakuDic:(NSDictionary *)danmakuDic {
    _danmakuDic = danmakuDic;
}

- (NSDictionary *)danmakuDic {
    return _danmakuDic;
}

- (NSString *)fileName {
    return _fileName;
}

- (NSString *)danmaku {
    return _danmaku;
}

- (NSURL *)fileURL {
    NSArray *arr = [self URLsForQuality];
    return _URLIndex < arr.count ? arr[_URLIndex] : nil;
}

- (NSString *)md5 {
    return [[_danmakuSourceStringValue stringByAppendingString:_danmaku] md5String];
}

- (DanDanPlayDanmakuSource)danmakuSource {
    return _danmakuSource;
}

#pragma mark - 私有方法 
/**
 *  根据当前清晰度获取对应地址数组
 *
 *  @return 地址数组
 */
- (NSArray <NSURL *>*)URLsForQuality {
    return self.quality == streamingVideoQualityHigh ? _URLs[@"high"] : _URLs[@"low"];
}
@end
