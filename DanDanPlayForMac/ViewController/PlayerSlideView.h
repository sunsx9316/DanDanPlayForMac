//
//  PlayerSlideView.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class PlayerSlideView;

@protocol PlayerSlideViewDelegate<NSObject>
@optional
/**
 *  点击控制条事件
 *
 *  @param endValue         点击位置占总长度的百分比
 *  @param PlayerSliderView PlayerSliderView
 */
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView;
/**
 *  拖拽控制条事件
 *
 *  @param endValue         拖拽位置占总长度的百分比
 *  @param PlayerSliderView PlayerSliderView
 */
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)PlayerSliderView;
@end

@interface PlayerSlideView : NSView
@property (weak, nonatomic) id<PlayerSlideViewDelegate> delegate;
@property (strong, nonatomic) NSColor *backGroundColor;
@property (strong, nonatomic) NSColor *progressSliderColor;
@property (strong, nonatomic) NSColor *bufferSliderColor;
- (void)updateCurrentProgress:(CGFloat)progress;
- (void)updateBufferProgress:(CGFloat)progress;
@end
