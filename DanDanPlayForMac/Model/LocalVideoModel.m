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
    NSURL *_fileURL;
    NSString *_fileName;
    NSString *_length;
    NSString *_md5;
}

- (instancetype)initWithFilePath:(NSString *)filePath{
    return [self initWithFileURL:[NSURL fileURLWithPath:filePath]];
}

- (instancetype)initWithFileURL:(NSURL *)fileURL{
    if (self = [super init]) {
        _fileURL = fileURL;
    }
    return self;
}

- (NSString *)fileName{
    if (_fileName == nil) {
        _fileName = [[_fileURL.path lastPathComponent] stringByDeletingPathExtension];
    }
    return _fileName;
}

- (NSURL *)filePath{
    return _fileURL;
}


- (NSString *)md5{
    if (_md5 == nil) {
        _md5 = [[[NSFileHandle fileHandleForReadingFromURL:_fileURL error:nil] readDataOfLength: 16777216] md5String];
    }
    return _md5;
}

- (NSString *)length{
    if (_length == nil) {
        _length = [[[NSFileManager defaultManager] attributesOfItemAtPath:_fileURL.path error:nil][@"NSFileSize"] stringValue];
    }
    return _length;
}

@end
