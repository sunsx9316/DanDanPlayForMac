//
//  JHProgressHUD.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHProgressHUD.h"
#import "NSProgressIndicator+Tools.h"
@interface JHProgressHUD()
@property (strong, nonatomic) NSView *blackBackGroundMask;
@property (strong, nonatomic) NSProgressIndicator *indicator;
@property (strong, nonatomic) NSTextField *textField;
@end

@implementation JHProgressHUD
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setWithDefaultParameter];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setWithDefaultParameter];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.hideWhenClick) {
        [self hideWithCompletion:nil];
    }
}

- (void)layout {
    float width = CGRectGetWidth(self.bounds);
    float height = CGRectGetHeight(self.bounds);
    
    CGRect indicatorFrame = self.indicator.frame;
    indicatorFrame.origin = CGPointMake((width - CGRectGetWidth(indicatorFrame)) / 2, (height - CGRectGetHeight(indicatorFrame)) / 2);
    self.indicator.frame = indicatorFrame;
    self.textField.frame = CGRectMake((width - CGRectGetWidth(self.textField.frame)) / 2, CGRectGetMinY(self.indicator.frame) - 20, CGRectGetWidth(self.textField.frame), CGRectGetHeight(self.textField.frame));
    [super layout];
}

#pragma mark setter getter
- (void)setWithDefaultParameter {
    self.wantsLayer = YES;
    self.autoresizingMask =  NSViewWidthSizable | NSViewHeightSizable;
    self.alphaValue = 0;
    _hideWhenClick = YES;
    self.style = JHProgressHUDStyleValue1;
    [self addSubview:self.blackBackGroundMask];
    [self addSubview:self.indicator];
    [self addSubview:self.textField];
}

- (void)setTextFont:(NSFont *)textFont {
    self.textField.font = textFont;
    [self.textField sizeToFit];
}

- (NSFont *)textFont {
    return self.textField.font;
}

- (void)setTextColor:(NSColor *)textColor {
    self.textField.textColor = textColor;
}

- (NSColor *)textColor {
    return self.textField.textColor;
}

- (void)setIndicatorColor:(NSColor *)indicatorColor {
    self.indicator.color = indicatorColor;
}

- (NSColor *)indicatorColor {
    return self.indicator.color;
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    CGRect frame = self.indicator.frame;
    frame.size = indicatorSize;
    self.indicator.frame = frame;
}

- (CGSize)indicatorSize {
    return self.indicator.frame.size;
}

- (void)setText:(NSString *)text {
    if (text.length == 0) return;
    self.textField.stringValue = text;
    [self.textField sizeToFit];
}

- (NSString *)text {
    return self.textField.stringValue;
}

- (void)setProgress:(float)progress {
    self.indicator.doubleValue = progress;
}

- (float)progress {
    return self.indicator.doubleValue;
}

- (void)setStyle:(JHProgressHUDStyle)style {
    //不会停止的进度
    self.indicator.indeterminate = (style == JHProgressHUDStyleValue1 || style == JHProgressHUDStyleValue3);
    
    if (style == JHProgressHUDStyleValue1 || style == JHProgressHUDStyleValue2) {
        self.indicator.style = NSProgressIndicatorSpinningStyle;
    }
    else {
        self.indicator.style = NSProgressIndicatorBarStyle;
    }
}

#pragma mark
+ (instancetype)shareProgressHUD {
    static dispatch_once_t onceToken;
    static JHProgressHUD *aHud = nil;
    dispatch_once(&onceToken, ^{
        aHud = [[JHProgressHUD alloc] init];
    });
    return aHud;
}

- (void)showWithView:(NSView *)view {
    [self showWithView:view anime:YES];
}

- (void)showWithView:(NSView *)view anime:(BOOL)anime {
    if (!view) {
        view = NSApp.keyWindow.contentViewController.view;
    }
    NSAssert(view, @"父视图为空");
    
    [self hideWithCompletion:nil anime:NO];
    [view addSubview:self];
    CGRect frame = view.bounds;
    self.frame = frame;
    self.blackBackGroundMask.frame = frame;
    [self.indicator startAnimation:nil];
    _isShowing = YES;
    
    if (anime) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            context.duration = 1;
            self.animator.alphaValue = 1;
        } completionHandler:nil];
    }
    else {
        self.animator.alphaValue = 1;
    }
}

- (void)hideWithCompletion:(void(^)())completion {
    [self hideWithCompletion:completion anime:YES];
}

- (void)hideWithCompletion:(void(^)())completion anime:(BOOL)anime {
    if (anime) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            context.duration = 1;
            self.animator.alphaValue = 0;
        } completionHandler:^{
            [self.indicator stopAnimation: self];
            self.progress = 0;
            [self removeFromSuperview];
            _isShowing = NO;
            if (completion) {
                completion();
            }
        }];
    }
    else {
        [self.indicator stopAnimation: self];
        self.progress = 0;
        self.alphaValue = 0;
        [self removeFromSuperview];
        _isShowing = NO;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - 懒加载
- (NSProgressIndicator *)indicator {
    if(_indicator == nil) {
        _indicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake((self.frame.size.width - 30) / 2, (self.frame.size.height - 30) / 2, 30, 30)];
        _indicator.style = NSProgressIndicatorSpinningStyle;
        _indicator.minValue = 0;
        _indicator.maxValue = 1;
    }
    return _indicator;
}

- (NSView *)blackBackGroundMask {
    if(_blackBackGroundMask == nil) {
        _blackBackGroundMask = [[NSView alloc] initWithFrame:self.bounds];
        [_blackBackGroundMask setWantsLayer: YES];
        [_blackBackGroundMask.layer setBackgroundColor: [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
        _blackBackGroundMask.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    return _blackBackGroundMask;
}

- (NSTextField *)textField {

	if(_textField == nil) {
		_textField = [[NSTextField alloc] init];
        _textField.editable = NO;
        _textField.drawsBackground = NO;
        _textField.bordered = NO;
        _textField.textColor = [NSColor whiteColor];
	}
	return _textField;
}

@end
