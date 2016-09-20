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
@property (strong, nonatomic) NSDictionary <NSNumber *, NSArray <NSURL *>*>*URLs;
@property (strong, nonatomic) NSString *danmakuSourceStringValue;

@end

@implementation StreamingVideoModel
{
    NSDictionary *_danmakuDic;
}
@synthesize matchTitle;
@synthesize episodeId;

- (instancetype)initWithFileURLs:(NSDictionary *)fileURLs fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(DanDanPlayDanmakuSource)danmakuSource {
    if (self = [super init]) {
        _URLs = fileURLs;
        _fileName = fileName;
        _danmaku = danmaku;
        _danmakuSource = danmakuSource;
    }
    return self;
}

- (streamingVideoQuality)quality {
    if (_quality == streamingVideoQualityHigh && !_URLs[@(streamingVideoQualityHigh)].count) {
        _quality = streamingVideoQualityLow;
    }
    return _quality;
}

- (NSInteger)URLsCountWithQuality:(streamingVideoQuality)quality {
    return _URLs[@(quality)].count;
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

- (NSString *)matchTitle {
    return _fileName;
}

- (NSString *)danmaku {
    return _danmaku;
}

- (NSURL *)fileURL {
    NSArray *arr = _URLs[@(_quality)];
    return _URLIndex < arr.count ? arr[_URLIndex] : nil;
}

- (NSString *)md5 {
    _md5 = [[_danmakuSourceStringValue stringByAppendingString:_danmaku] md5String];
    return _md5;
}

- (DanDanPlayDanmakuSource)danmakuSource {
    return _danmakuSource;
}

- (NSUInteger)hash {
    return _fileName.hash | _danmaku.hash | _danmakuSource;
}

- (BOOL)isEqual:(StreamingVideoModel *)object {
    if (![self isKindOfClass:[object class]]) return NO;
    if (self == object) return YES;
    if ([self.fileName isEqual:object.fileName] && [self.danmaku isEqual:object.danmaku] && self.danmakuSource == object.danmakuSource) return YES;
    return [super isEqual:object];
}


@end
