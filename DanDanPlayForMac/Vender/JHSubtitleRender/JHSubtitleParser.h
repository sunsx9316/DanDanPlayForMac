//
//  JHSubtitleParser.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  字幕解析器
 */
@interface JHSubtitleParser : NSObject
/**
 *  解析字幕
 *
 *  @param path     字幕路径
 *  @param encoding 编码格式
 *
 *  @return 字幕对应的时间字典
 */
+ (NSDictionary *)subtitleDicWithPath:(NSString *)path encoding:(NSStringEncoding)encoding;
/**
 *  解析字幕 默认编码 NSUnicodeStringEncoding
 *
 *  @param path     字幕路径
 *
 *  @return 字幕对应的时间字典
 */
+ (NSDictionary *)subtitleDicWithPath:(NSString *)path;
@end
