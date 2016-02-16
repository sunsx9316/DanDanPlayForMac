//
//  SliderControlCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>

typedef void(^slideBlock)(CGFloat value);
typedef NS_ENUM(NSUInteger, sliderControlStyle) {
    sliderControlStyleFontSize,
    sliderControlStyleSpeed,
    sliderControlStyleOpacity
};

@interface SliderControlCell : NSView
- (void)setWithBlock:(slideBlock)block sliderControlStyle:(sliderControlStyle)style;
@end
