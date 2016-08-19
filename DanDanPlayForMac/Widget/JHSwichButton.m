//
//  JHSwichButton.m
//  JHSwichButton
//
//  Created by JimHuang on 16/8/3.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "JHSwichButton.h"
#import "NSView+Tools.h"
#import <Quartz/Quartz.h>

@interface JHSwichButton ()
@property (strong, nonatomic) NSView *signView;
@property (strong, nonatomic) NSView *backgroundView;
@end

@implementation JHSwichButton
{
    __weak id _target;
    SEL _action;
    NSColor *_signTintColor;
    NSColor *_openColor;
    NSColor *_closeColor;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.signView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.backgroundView];
    [self addSubview:self.signView];
}

#pragma mark - 鼠标事件
- (void)mouseDown:(NSEvent *)theEvent {
    CGRect frame = self.signView.frame;
    frame.size.width += 5;
    if (_status) {
        frame.origin.x -= 5;
    }
    self.signView.animator.frame = frame;
}

- (void)mouseUp:(NSEvent *)theEvent {
    _status = !_status;
    [_target performSelector:_action withObject:self afterDelay:0];
    [self changeSignViewFrame:YES];
}

- (void)setStatus:(BOOL)status {
    _status = status;
    [self changeSignViewFrame:NO];
}

- (void)setSignTintColor:(NSColor *)signTintColor {
    _signTintColor = signTintColor;
    self.signView.backgroundColor = _signTintColor;
}

- (void)setOpenColor:(NSColor *)openColor {
    _openColor = openColor;
    if (_status == YES) {
        self.backgroundView.backgroundColor = _openColor;
    }
}

- (void)setCloseColor:(NSColor *)closeColor {
    _closeColor = closeColor;
    if (_status == NO) {
        self.backgroundView.backgroundColor = _closeColor;
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

#pragma mark - 私有方法
- (void)changeSignViewFrame:(BOOL)animate {
    CGRect viewFrame = self.frame;
    if (animate) {
        if (!_status) {
            self.signView.animator.frame = CGRectMake(0, 0, viewFrame.size.width / 2, viewFrame.size.height);
            CABasicAnimation *colorAnimate = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
            colorAnimate.fromValue = (__bridge id _Nullable)(self.openColor.CGColor);
            colorAnimate.toValue = (__bridge id _Nullable)(self.closeColor.CGColor);
            colorAnimate.removedOnCompletion = NO;
            colorAnimate.fillMode = kCAFillModeForwards;
            
            [self.backgroundView.layer addAnimation:colorAnimate forKey:nil];
        }
        else {
            self.signView.animator.frame = CGRectMake(viewFrame.size.width / 2, 0,viewFrame.size.width / 2, viewFrame.size.height);
            
            CABasicAnimation *colorAnimate = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
            colorAnimate.fromValue = (__bridge id _Nullable)(self.closeColor.CGColor);
            colorAnimate.toValue = (__bridge id _Nullable)(self.openColor.CGColor);
            colorAnimate.removedOnCompletion = NO;
            colorAnimate.fillMode = kCAFillModeForwards;
            
            [self.backgroundView.layer addAnimation:colorAnimate forKey:nil];
        }
    }
    else {
        if (!_status) {
            self.signView.frame = CGRectMake(0, 0, viewFrame.size.width / 2, viewFrame.size.height);
            self.backgroundView.backgroundColor = self.closeColor;
        }
        else {
            self.signView.frame = CGRectMake(viewFrame.size.width / 2, 0,viewFrame.size.width / 2, viewFrame.size.height);
            self.backgroundView.backgroundColor = self.openColor;
        }
    }
}

#pragma mark - 懒加载
- (NSView *)signView {
	if(_signView == nil) {
		_signView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height)];

        _signView.backgroundColor = self.signTintColor;
        _signView.layer.borderWidth = 1;
        _signView.layer.borderColor = [NSColor lightGrayColor].CGColor;
        CGFloat minVlue = MIN(_signView.frame.size.width, _signView.frame.size.height) / 2;
        _signView.layer.cornerRadius = minVlue;
	}
	return _signView;
}

- (NSColor *)signTintColor {
    if(_signTintColor == nil) {
        _signTintColor = [NSColor whiteColor];
    }
    return _signTintColor;
}

- (NSView *)backgroundView {
	if(_backgroundView == nil) {
		_backgroundView = [[NSView alloc] initWithFrame:self.bounds];
        CGFloat minVlue = MIN(_backgroundView.frame.size.width, _backgroundView.frame.size.height) / 2;
        _backgroundView.backgroundColor = self.closeColor;
        _backgroundView.layer.cornerRadius = minVlue;
	}
	return _backgroundView;
}

- (NSColor *)openColor {
    if(_openColor == nil) {
        _openColor = [NSColor greenColor];
    }
    return _openColor;
}

- (NSColor *)closeColor {
    if(_closeColor == nil) {
        _closeColor = [NSColor lightGrayColor];
    }
    return _closeColor;
}

@end
