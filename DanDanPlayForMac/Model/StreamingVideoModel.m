//
//  StreamingVideoModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "StreamingVideoModel.h"
#import "NSString+Tools.h"
@interface StreamingVideoModel()
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *danmaku;
@property (strong, nonatomic) NSString *danmakuSource;
@property (strong, nonatomic) NSDictionary *URLs;
@end

@implementation StreamingVideoModel
- (instancetype)initWithFileURLs:(NSDictionary *)fileURLs fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(NSString *)danmakuSource{
    if (self = [super init]) {
        _URLs = fileURLs;
        _fileName = fileName;
        _danmaku = danmaku;
        _danmakuSource = danmakuSource;
    }
    return self;
}

- (streamingVideoQuality)quality{
    if (_quality == streamingVideoQualityHigh && ![_URLs[@"high"] count]) {
        _quality = streamingVideoQualityLow;
    }
    return _quality;
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
    return self.quality == streamingVideoQualityHigh ? _URLs[@"high"] : _URLs[@"low"];
}
@end
