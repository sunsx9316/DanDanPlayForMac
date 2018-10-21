//
//  VideoModel.m
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "LocalVideoModel.h"
#import "NSData+Tools.h"
@interface LocalVideoModel()
@property (strong, nonatomic) NSURL *fileURL;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *length;
@property (strong, nonatomic) NSString *md5;
@end

@implementation LocalVideoModel
{
    NSDictionary *_danmakuDic;
}

@synthesize matchTitle;
@synthesize episodeId;
@synthesize progress;

- (instancetype)initWithFileURL:(NSURL *)fileURL {
    if (self = [super init]) {
        _fileURL = fileURL;
    }
    return self;
}

- (NSString *)fileName {
    if (_fileName == nil) {
        _fileName = [[_fileURL.path lastPathComponent] stringByDeletingPathExtension];
    }
    return _fileName;
}


- (NSURL *)fileURL {
    return _fileURL;
}

- (NSString *)md5 {
    if (_md5 == nil) {
        _md5 = [[[NSFileHandle fileHandleForReadingFromURL:_fileURL error:nil] readDataOfLength: 16777216] md5String];
    }
    return _md5;
}

- (NSString *)length {
    if (_length == nil) {
        _length = [[[NSFileManager defaultManager] attributesOfItemAtPath:_fileURL.path error:nil][@"NSFileSize"] stringValue];
    }
    return _length;
}

- (void)setDanmakuDic:(NSDictionary *)danmakuDic {
    _danmakuDic = danmakuDic;
}

- (NSDictionary *)danmakuDic {
    return _danmakuDic;
}

- (NSUInteger)hash {
    return self.fileURL.hash;
}

- (BOOL)isEqual:(LocalVideoModel *)object {
    if (![self isKindOfClass:[object class]]) return NO;
    if (self == object) return YES;
    if ([self.fileURL isEqual:object.fileURL]) return YES;
    return [super isEqual:object];
}

@end
