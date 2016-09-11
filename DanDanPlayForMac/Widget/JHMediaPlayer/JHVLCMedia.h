//
//  JHVLCMedia.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <VLCKit/VLCKit.h>

typedef void(^parseCompleteBlock)(CGSize size);
@interface JHVLCMedia : VLCMedia
/**
 *  解析方法回调
 *
 *  @param block 回调方法
 */
- (void)parseWithBlock:(parseCompleteBlock)block;
- (instancetype)initWithURL:(NSURL *)anURL;
- (instancetype)initWithPath:(NSString *)aPath;
@end
