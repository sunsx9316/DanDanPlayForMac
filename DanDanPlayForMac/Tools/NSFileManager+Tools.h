//
//  NSFileManager+Tools.h
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/23.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Tools)
/**
 *  遍历路径获得文件/文件夹大小，返回多少kb
 *
 *  @param folderPath   文件/文件夹路径
 *  @param excludePaths 排除的路径
 *
 *  @return 文件/文件夹大小
 */
- (CGFloat)folderSizeAtPath:(NSString *)folderPath excludePaths:(NSArray *)excludePaths;
@end
