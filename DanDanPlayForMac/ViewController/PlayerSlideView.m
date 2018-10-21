//
//  PlayerSlideView.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSlideView.h"
#import <POP.h>

@interface PlayerSlideView()
//@property (strong, nonatomic) NSImageView *progressSliderImgView;
//@property (strong, nonatomic) NSImageView *bufferSliderImgView;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@property (strong, nonatomic) NSSlider *slider;
@end

@implementation PlayerSlideView
{
    NSColor *_backGroundColor;
    NSColor *_progressSliderColor;
    NSColor *_bufferSliderColor;
//    CGFloat _progress;
//    CGFloat _bufferProgress;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - 方法
- (void)setCurrentProgress:(float)currentProgress {
    if (isnan(currentProgress)) currentProgress = 0;
    _currentProgress = currentProgress;
//    NSLog(@"%f", currentProgress);
    self.slider.doubleValue = _currentProgress;
//    self.progressSliderImgView.image = [self drawProgressImgWithProgressValue:_currentProgress color:self.progressSliderColor];
}

- (void)setBufferProgress:(float)bufferProgress {
    if (isnan(bufferProgress)) bufferProgress = 0;
    _bufferProgress = bufferProgress;
//    self.bufferSliderImgView.image = [self drawProgressImgWithProgressValue:_bufferProgress color:self.bufferSliderColor];
}

//- (void)resizeWithOldSuperviewSize:(NSSize)oldSize{
//    [super resizeWithOldSuperviewSize:oldSize];
//    self.bufferSliderImgView.frame = self.bounds;
//    self.progressSliderImgView.frame = self.bounds;
//    self.currentProgress = _currentProgress;
//    self.bufferProgress = _bufferProgress;
//}

//- (void)mouseDragged:(NSEvent *)theEvent{
//    CGFloat value = [self progressValueWithPoint:theEvent.locationInWindow];
//    if (value >= 0 && value <= 1){
//        if ([self.delegate respondsToSelector:@selector(playerSliderDraggedEnd:playerSliderView:)]) {
//            self.currentProgress = value;
//            [self.delegate playerSliderDraggedEnd: value playerSliderView: self];
//        }
//    }
//}

- (void)mouseMoved:(NSEvent *)theEvent{
    CGFloat value = [self convertPoint:theEvent.locationInWindow fromView:[NSApp keyWindow].contentView].x / self.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(playerSliderMoveEnd:endValue:playerSliderView:)]) {
            [self.delegate playerSliderMoveEnd:theEvent.locationInWindow endValue:value playerSliderView:self];
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

//- (void)mouseUp:(NSEvent *)theEvent{
//    CGFloat value = [self progressValueWithPoint:theEvent.locationInWindow];
//    if (value >= 0 && value <= 1){
//        if ([self.delegate respondsToSelector:@selector(playerSliderTouchEnd:playerSliderView:)]) {
//            self.currentProgress = value;
//            [self.delegate playerSliderTouchEnd: value playerSliderView: self];
//        }
//    }
//}

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
- (CGFloat)progressValueWithPoint:(CGPoint)point {
//    point = [self convertPoint:point fromView:[NSApp keyWindow].contentView];
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

- (void)clickSlider:(NSSlider *)slider {
    CGFloat value = slider.doubleValue;
    if (value >= 0 && value <= 1){
        if ([self.delegate respondsToSelector:@selector(playerSliderDraggedEnd:playerSliderView:)]) {
            self.currentProgress = value;
            [self.delegate playerSliderDraggedEnd: value playerSliderView: self];
        }
    }
}

#pragma mark - 懒加载

- (NSColor *)progressSliderColor {
    if(_progressSliderColor == nil) {
        _progressSliderColor = [NSColor mainColor];
    }
    return _progressSliderColor;
}

- (NSColor *)backGroundColor{
    if (_backGroundColor == nil) {
        _backGroundColor = DDPRGBColor(51, 55, 69);
    }
    return _backGroundColor;
}

- (NSColor *)bufferSliderColor {
    if(_bufferSliderColor == nil) {
        _bufferSliderColor = [NSColor grayColor];
    }
    return _bufferSliderColor;
}

- (NSSlider *)slider {
    if (_slider == nil) {
        _slider = [[NSSlider alloc] init];
        _slider.target = self;
        _slider.action = @selector(clickSlider:);
        [self addSubview:_slider];
    }
    return _slider;
}

//- (NSImageView *)progressSliderImgView {
//    if(_progressSliderImgView == nil) {
//        _progressSliderImgView = [[NSImageView alloc] initWithFrame:self.bounds];
//        [self addSubview:_progressSliderImgView];
//    }
//    return _progressSliderImgView;
//}
//
//- (NSImageView *)bufferSliderImgView {
//    if(_bufferSliderImgView == nil) {
//        _bufferSliderImgView = [[NSImageView alloc] initWithFrame:self.bounds];
//        [self addSubview:_bufferSliderImgView];
//    }
//    return _bufferSliderImgView;
//}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInKeyWindow | NSTrackingMouseMoved | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
    return _trackingArea;
}

@end
