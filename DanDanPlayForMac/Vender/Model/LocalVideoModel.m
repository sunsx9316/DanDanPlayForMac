//
//  VideoModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "LocalVideoModel.h"
#import "NSData+Tools.h"

@implementation LocalVideoModel
{
    NSString *_filePath;
    NSString *_fileName;
    NSString *_length;
    NSString *_md5;
}

- (instancetype)initWithFilePath:(NSString *)filePath{
    if (self = [super init]) {
        _filePath = filePath;
    }
    return self;
}

- (NSString *)fileName{
    if (_fileName == nil) {
        _fileName = [[_filePath lastPathComponent] stringByDeletingPathExtension];
    }
    return _fileName;
}

- (NSString *)filePath{
    return _filePath;
}

- (NSString *)md5{
    if (_md5 == nil) {
        _md5 = [[[NSFileHandle fileHandleForReadingAtPath: _filePath] readDataOfLength: 16777216] md5String];
    }
    return _md5;
}

- (NSString *)length{
    if (_length == nil) {
        _length = [[[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil][@"NSFileSize"] stringValue];
    }
    return _length;
}

@end
