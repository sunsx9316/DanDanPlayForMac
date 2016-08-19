//
//  JHDanmakuHeader.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef JHDanmakuHeader_h
#define JHDanmakuHeader_h

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define JHLabel UILabel
#define JHAttributedText attributedText
#define JHText text
#define JHColor UIColor
#define JHFont UIFont
#define JHColorBrightness(color) ({ \
CGFloat b;\
[color getHue:nil saturation:nil brightness:&b alpha:nil];\
b;\
})
#define JHView UIView

#else

#import <Cocoa/Cocoa.h>
#define JHLabel NSTextField
#define JHAttributedText attributedStringValue
#define JHText stringValue
#define JHColor NSColor
#define JHFont NSFont
#define JHColorBrightness(color) color.brightnessComponent
#define JHView NSView
#endif

#endif /* JHDanmakuHeader_h */
