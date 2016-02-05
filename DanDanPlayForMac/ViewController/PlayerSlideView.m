//
//  PlayerSlideView.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSlideView.h"
#import "Masonry.h"
@interface PlayerSlideView()
@property (strong, nonatomic) NSView *sliderView;
@end


@implementation PlayerSlideView
{
    NSColor *_backGroundColor;
    NSColor *_sliderColor;
}
#pragma mark - 方法
- (void)updateCurrentTime:(CGFloat)currentTime{
    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.equalTo(self).multipliedBy(currentTime);
    }];
}

- (void)mouseDragged:(NSEvent *)theEvent{
    CGFloat value = (theEvent.locationInWindow.x - self.frame.origin.x) / self.frame.size.width;
    if (value >= 0 && value <= 1){
        if ([self.delegate respondsToSelector:@selector(playerSliderDraggedEnd:playerSliderView:)]) {
            [self updateCurrentTime: value];
            [self.delegate playerSliderDraggedEnd: value playerSliderView: self];
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent{
    CGFloat value = (theEvent.locationInWindow.x - self.frame.origin.x) / self.frame.size.width;
    if (value >= 0 && value <= 1){
        if ([self.delegate respondsToSelector:@selector(playerSliderTouchEnd:playerSliderView:)]) {
            [self updateCurrentTime: value];
            [self.delegate playerSliderTouchEnd: value playerSliderView: self];
        }
    }
}

//- (void)scrollWheel:(NSEvent *)theEvent{
//     NSLog(@"%f", theEvent.scrollingDeltaY);
//}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setWantsLayer: YES];
    self.layer.backgroundColor = self.backGroundColor.CGColor;
    [self addSubview: self.sliderView];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
    }];
}

- (void)setBackGroundColor:(NSColor *)backGroundColor{
    _backGroundColor = backGroundColor;
    self.layer.backgroundColor = backGroundColor.CGColor;
}

- (void)setSliderColor:(NSColor *)sliderColor{
    _sliderColor = sliderColor;
    self.sliderView.layer.backgroundColor = sliderColor.CGColor;
}

#pragma mark - 懒加载

- (NSColor *)sliderColor {
    if(_sliderColor == nil) {
        _sliderColor = [NSColor darkGrayColor];
    }
    return _sliderColor;
}

- (NSColor *)backGroundColor{
    if (_backGroundColor == nil) {
        _backGroundColor = [NSColor gridColor];
    }
    return _backGroundColor;
}

- (NSView *)sliderView {
	if(_sliderView == nil) {
		_sliderView = [[NSView alloc] init];
        [_sliderView setWantsLayer: YES];
        _sliderView.layer.backgroundColor = self.sliderColor.CGColor;
	}
	return _sliderView;
}

@end
