//
//  JHSubtitleHeader.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

//跨平台用的头文件
#ifndef JHSubtitleHeader_h
#define JHSubtitleHeader_h

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define JHView UIView
#define JHColor UIColor
#define JHFont UIFont
#define JHLabel UILabel
#define JHAttributedText attributedText
#define JHText text

#define JHColorBrightness(color) ({ \
CGFloat b;\
[color getHue:nil saturation:nil brightness:&b alpha:nil];\
b;\
})

#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#define JHView NSView
#define JHColor NSColor
#define JHFont NSFont
#define JHLabel NSTextField
#define JHAttributedText attributedStringValue
#define JHText stringValue
#define JHColorBrightness(color) color.brightnessComponent
#endif

#endif /* JHSubtitleHeader_h */
