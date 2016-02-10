//
//  JHVLCMedia.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <VLCKit/VLCKit.h>

typedef void(^complete)(VLCMedia *aMedia);
@interface JHVLCMedia : VLCMedia
/**
 *  解析方法回调
 *
 *  @param block 回调方法
 */
- (void)parseWithBlock:(complete)block;
- (instancetype)initWithURL:(NSURL *)anURL;
- (instancetype)initWithPath:(NSString *)aPath;
@end
