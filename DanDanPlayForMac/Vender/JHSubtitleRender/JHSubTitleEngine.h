//
//  JHSubTitleEngine.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSubTitleCanvas.h"
#import "JHSubtitle.h"

@interface JHSubTitleEngine : NSObject
@property (strong, nonatomic) JHSubTitleCanvas *canvas;
//当前时间
@property (assign, nonatomic) NSTimeInterval currentTime;
//偏移时间 让字幕偏移一般设置这个就行
@property (assign, nonatomic) NSTimeInterval offsetTime;
//全局文字风格字典 默认不使用 会覆盖个体设置
@property (strong, nonatomic) NSDictionary *globalAttributedDic;

//设置是否在画布尺寸变化时重新计算字幕的初始位置 默认NO 只在OSX有效
#if !TARGET_OS_IPHONE
@property (assign, nonatomic, getter=isResetSubtitlePositionWhenCanvasSizeChange) BOOL resetSubtitlePositionWhenCanvasSizeChange;
#endif
//全局速度 默认1.0
- (void)setSpeed:(float)speed;
//暂停状态就是恢复运动
- (void)start;
- (void)stop;
- (void)pause;
/**
 *  从路径添加字幕
 *
 *  @param path 路径
 */
- (void)addSubTitleWithPath:(NSString *)path;
/**
 *  从媒体路径猜测字幕路径
 *
 *  @param path 媒体路径
 */
- (void)addSubTitleWithMediaPath:(NSString *)path;
@end
