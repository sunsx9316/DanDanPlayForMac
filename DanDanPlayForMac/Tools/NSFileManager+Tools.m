//
//  NSFileManager+Tools.m
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/23.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSFileManager+Tools.h"

@implementation NSFileManager (Tools)
- (CGFloat)folderSizeAtPath:(NSString*)folderPath excludePaths:(NSArray <NSString *>*)excludePaths {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *subpath = nil;
    NSUInteger folderSize = 0;
    while ((subpath = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:subpath];
        
        BOOL isEnclude = NO;
        for (NSString *aPath in excludePaths) {
            if ([self childPath:fileAbsolutePath isEncludeInParentPath:aPath]) {
                isEnclude = YES;
                break;
            }
        }
        if (!isEnclude) {
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    return folderSize / 1024.0;
}

/**
 *  判断一个路径是否包含另一个路径
 *
 *  @param path  子路径
 *  @param aPath 父路径
 *
 *  @return 是否包含
 */
- (BOOL)childPath:(NSString *)childPath isEncludeInParentPath:(NSString *)parentPath {
    return [childPath rangeOfString:parentPath].location != NSNotFound;
}

#pragma mark - 计算单个文件大小
- (NSInteger)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
