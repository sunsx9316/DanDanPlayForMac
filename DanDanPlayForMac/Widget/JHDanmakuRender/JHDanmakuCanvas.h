//
//  JHDanmakuCanvas.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

/**
 *  弹幕画布自动布局风格
 */
typedef NS_ENUM(NSUInteger, JHDanmakuCanvasLayoutStyle) {
    /**
     *  不自动布局
     */
    JHDanmakuCanvasLayoutStyleNone,
    /**
     *  在尺寸变化时就布局
     */
    JHDanmakuCanvasLayoutStyleWhenSizeChanging,
    /**
     *  在尺寸变化结束之后布局
     */
    JHDanmakuCanvasLayoutStyleWhenSizeChanged,
};

#import <Foundation/Foundation.h>
#import "JHDanmakuHeader.h"

@interface JHDanmakuCanvas : JHView
//画布布局风格 默认JHDanmakuCanvasLayoutStyleNone
@property (assign, nonatomic) JHDanmakuCanvasLayoutStyle layoutStyle;
@property (copy, nonatomic) void(^resizeCallBackBlock)(CGRect bounds);
@end
