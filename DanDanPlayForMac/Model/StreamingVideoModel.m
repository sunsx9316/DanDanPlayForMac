//
//  StreamingVideoModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "StreamingVideoModel.h"

@implementation StreamingVideoModel
{
    NSString *_fileName;
    NSString *_danmaku;
    NSURL *_filePath;
    NSString *_danmakuSource;
}
- (instancetype)initWithFileURL:(NSURL *)fileURL fileName:(NSString *)fileName danmaku:(NSString *)danmaku danmakuSource:(NSString *)danmakuSource{
    if (self = [super init]) {
        _filePath = fileURL;
        _fileName = fileName;
        _danmaku = danmaku;
        _danmakuSource = danmakuSource;
    }
    return self;
}

- (NSString *)fileName{
    return _fileName;
}

- (NSString *)danmaku{
    return _danmaku;
}

- (NSURL *)filePath{
    return _filePath;
}

- (NSString *)danmakuSource{
    return _danmakuSource;
}
@end
