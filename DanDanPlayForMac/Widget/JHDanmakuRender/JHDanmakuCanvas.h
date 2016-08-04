//
//  JHDanmakuCanvas.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JHDanmakuHeader.h"

@interface JHDanmakuCanvas : JHView
#if !TARGET_OS_IPHONE
@property (copy, nonatomic) void(^resizeCallBackBlock)(CGRect bounds);
#endif
@end
