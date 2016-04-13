//
//  JHDanmakuCanvas.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define JHView UIView
#else
#import <Cocoa/Cocoa.h>
#define JHView NSView
#endif

@interface JHDanmakuCanvas : JHView
#if !TARGET_OS_IPHONE
@property (copy, nonatomic) void(^resizeCallBackBlock)(CGRect bounds);
#endif
@end
