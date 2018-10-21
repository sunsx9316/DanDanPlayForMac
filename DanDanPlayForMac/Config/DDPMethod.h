//
//  DDPMethod.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 2018/10/21.
//  Copyright © 2018 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPMethod : NSObject

/**
 请求路径
 
 @return 请求路径
 */
+ (NSString *)apiPath;

/**
 v2请求路径
 
 @return v2请求路径
 */
+ (NSString *)apiNewPath;

/**
 快速生成颜色
 
 @param r 红
 @param g 绿
 @param b 蓝
 @return 颜色
 */
FOUNDATION_EXPORT NSColor *DDPRGBColor(int r, int g, int b);

/**
 快速生成颜色
 
 @param r 红
 @param g 绿
 @param b 蓝
 @param a 透明度
 @return 颜色
 */
FOUNDATION_EXPORT NSColor *DDPRGBAColor(int r, int g, int b, CGFloat a);

@end

NS_ASSUME_NONNULL_END
