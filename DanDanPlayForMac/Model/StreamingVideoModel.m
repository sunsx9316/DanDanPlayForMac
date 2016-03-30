//
//  StreamingVideoModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "StreamingVideoModel.h"
#import "NSString+Tools.h"

@implementation StreamingVideoModel
{
    NSString *_fileName;
    NSString *_danmaku;
    NSString *_danmakuSource;
    NSDictionary *_URLs;
}
- (instancetype)initWithFileURLs:(NSDictionary *)fileURLs fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(NSString *)danmakuSource{
    if (self = [super init]) {
        _URLs = fileURLs;
        _fileName = fileName;
        _danmaku = danmaku;
        _danmakuSource = danmakuSource;
    }
    return self;
}

- (NSInteger)URLsCountWithQuality:(streamingVideoQuality)quality{
    NSArray *arr = quality == streamingVideoQualityLow ? _URLs[@"low"] : _URLs[@"high"];
    return arr.count;
}

- (NSString *)fileName{
    return _fileName;
}

- (NSString *)danmaku{
    return _danmaku;
}

- (NSURL *)filePath{
    NSArray *arr = [self URLsForQuality];
    return _URLIndex < arr.count ? arr[_URLIndex] : nil;
}

- (NSString *)md5{
    return [[_danmakuSource stringByAppendingString:_danmaku] md5String];
}

- (NSString *)danmakuSource{
    return _danmakuSource;
}

#pragma mark - 私有方法 
/**
 *  根据当前清晰度获取对应地址数组
 *
 *  @return 地址数组
 */
- (NSArray *)URLsForQuality{
    return self.quality == streamingVideoQualityLow ? _URLs[@"low"] : _URLs[@"high"];
}
@end
