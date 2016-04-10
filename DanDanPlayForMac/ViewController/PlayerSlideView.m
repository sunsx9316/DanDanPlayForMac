//
//  PlayerSlideView.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSlideView.h"
@interface PlayerSlideView()
@property (strong, nonatomic) NSImageView *progressSliderImgView;
@property (strong, nonatomic) NSImageView *bufferSliderImgView;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end


@implementation PlayerSlideView
{
    NSColor *_backGroundColor;
    NSColor *_progressSliderColor;
    NSColor *_bufferSliderColor;
    CGFloat _progress;
    CGFloat _bufferProgress;
}
#pragma mark - 方法
- (void)updateCurrentProgress:(CGFloat)progress{
    if (isnan(progress))  progress = 0;
    _progress = progress;
    self.progressSliderImgView.image = [self drawProgressImgWithProgressValue:progress color:self.progressSliderColor];
}

- (void)updateBufferProgress:(CGFloat)progress{
    if (isnan(progress)) progress = 0;
    _bufferProgress = progress;
    self.bufferSliderImgView.image = [self drawProgressImgWithProgressValue:progress color:self.bufferSliderColor];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize{
    [super resizeWithOldSuperviewSize:oldSize];
    self.bufferSliderImgView.frame = self.bounds;
    self.progressSliderImgView.frame = self.bounds;
    [self updateCurrentProgress:_progress];
    [self updateBufferProgress:_bufferProgress];
}

- (void)mouseDragged:(NSEvent *)theEvent{
    CGFloat value = [self progressValueWithPoint:theEvent.locationInWindow];
    if (value >= 0 && value <= 1){
        if ([self.delegate respondsToSelector:@selector(playerSliderDraggedEnd:playerSliderView:)]) {
            [self updateCurrentProgress: value];
            [self.delegate playerSliderDraggedEnd: value playerSliderView: self];
        }
    }
}

- (void)mouseMoved:(NSEvent *)theEvent{
    CGPoint point = [self convertPoint:theEvent.locationInWindow fromView:[NSApp keyWindow].contentView];
    CGFloat value = point.x / self.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(playerSliderMoveEnd:endValue:playerSliderView:)]) {
            [self.delegate playerSliderMoveEnd:point endValue:value playerSliderView:self];
        }
}

- (void)mouseExited:(NSEvent *)theEvent{
    if (self.mouseExitedCallBackBlock) {
        self.mouseExitedCallBackBlock();
    }
}

- (void)mouseEntered:(NSEvent *)theEvent{
    if (self.mouseEnteredCallBackBlock) {
        self.mouseEnteredCallBackBlock();
    }
}

- (void)mouseDown:(NSEvent *)theEvent{
    CGFloat value = [self progressValueWithPoint:theEvent.locationInWindow];
    if (value >= 0 && value <= 1){
        if ([self.delegate respondsToSelector:@selector(playerSliderTouchEnd:playerSliderView:)]) {
            [self updateCurrentProgress: value];
            [self.delegate playerSliderTouchEnd: value playerSliderView: self];
        }
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setWantsLayer: YES];
    self.layer.backgroundColor = self.backGroundColor.CGColor;
    [self addTrackingArea:self.trackingArea];
}

- (void)dealloc{
    [self removeTrackingArea:self.trackingArea];
}

- (void)setBackGroundColor:(NSColor *)backGroundColor{
    _backGroundColor = backGroundColor;
    self.layer.backgroundColor = backGroundColor.CGColor;
}

#pragma mark - 私有方法
- (CGFloat)progressValueWithPoint:(CGPoint)point{
    point = [self convertPoint:point fromView:[NSApp keyWindow].contentView];
    return point.x / self.frame.size.width;
}

- (NSImage *)drawProgressImgWithProgressValue:(float)value color:(NSColor *)color{
    CGSize size = self.bounds.size;
    float progressValue = size.width * value;
    NSImage *img = [[NSImage alloc] initWithSize:size];
    [img lockFocus];
    [color setFill];
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:CGRectMake(progressValue - size.height, 0, size.height, size.height)];
    [path fill];
    if (progressValue - size.height / 2 > 0) {
        [NSBezierPath fillRect:CGRectMake(0, 0, progressValue - size.height / 2, size.height)];
    }
    [img unlockFocus];
    return img;
}

#pragma mark - 懒加载

- (NSColor *)progressSliderColor {
    if(_progressSliderColor == nil) {
        _progressSliderColor = [NSColor colorWithRed:230 / 255.0 green:25 / 255.0 blue:73 / 255.0 alpha:1];
    }
    return _progressSliderColor;
}

- (NSColor *)backGroundColor{
    if (_backGroundColor == nil) {
        _backGroundColor = [NSColor colorWithRed:51 / 255.0 green:55 / 255.0 blue:69  /255.0 alpha:1];
    }
    return _backGroundColor;
}

- (NSColor *)bufferSliderColor {
    if(_bufferSliderColor == nil) {
        _bufferSliderColor = [NSColor lightGrayColor];
    }
    return _bufferSliderColor;
}

- (NSImageView *)progressSliderImgView {
    if(_progressSliderImgView == nil) {
        _progressSliderImgView = [[NSImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_progressSliderImgView];
    }
    return _progressSliderImgView;
}

- (NSImageView *)bufferSliderImgView {
    if(_bufferSliderImgView == nil) {
        _bufferSliderImgView = [[NSImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bufferSliderImgView];
    }
    return _bufferSliderImgView;
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInKeyWindow | NSTrackingMouseMoved | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
    return _trackingArea;
}

@end
