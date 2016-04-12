//
//  JHProgressHUD.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHProgressHUD.h"
static JHProgressHUD *_hud = nil;
@interface JHProgressHUD()
@property (assign, nonatomic) JHProgressHUDStyle style;
@property (strong, nonatomic) NSView *blackBackGroundMask;
@property (strong, nonatomic) NSProgressIndicator *indicator;
@property (weak, nonatomic) NSView *parentView;
@property (strong, nonatomic) NSTextField *text;
@property (assign, nonatomic) BOOL dismissWhenClick;
@property (assign, nonatomic) BOOL showing;
@end

@implementation JHProgressHUD
#pragma mark - 类方法
+ (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView indicatorSize:(NSSize)size fontSize:(CGFloat)fontSize dismissWhenClick:(BOOL)dismissWhenClick{
    JHProgressHUD *hud = [self shareHUD];
    [hud setMessage:message style:style parentView:parentView indicatorSize:size fontSize: fontSize dismissWhenClick: dismissWhenClick];
    [hud show];
}
+ (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView dismissWhenClick:(BOOL)dismissWhenClick{
    [self showWithMessage:message style:style parentView:parentView indicatorSize:CGSizeMake(30, 30) fontSize:[NSFont systemFontSize] dismissWhenClick:dismissWhenClick];
}

+ (void)showWithMessage:(NSString *)message parentView:(NSView *)parentView{
    [self showWithMessage:message style:JHProgressHUDStyleValue1 parentView:parentView dismissWhenClick: YES];
}

+ (void)disMiss{
    [[self shareHUD] disMiss];
}

+ (void)updateProgress:(CGFloat)progress{
    [[self shareHUD] updateProgress:progress];
}

+ (void)updateMessage:(NSString *)message{
    [[self shareHUD] updateMessage:message];
}


#pragma mark - 实例方法
- (instancetype)initWithMessage:(NSString *)message parentView:(NSView *)parentView{
    return [self initWithMessage:message style:JHProgressHUDStyleValue1 parentView:parentView dismissWhenClick:YES];
}

- (instancetype)initWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)
parentView dismissWhenClick:(BOOL)dismissWhenClick{
    return [self initWithMessage:message style:style parentView:parentView indicatorSize:CGSizeMake(30, 30) fontSize:[NSFont systemFontSize] dismissWhenClick:YES];
}

- (instancetype)initWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView indicatorSize:(NSSize)size fontSize:(CGFloat)fontSize dismissWhenClick:(BOOL)dismissWhenClick{
    if (self = [super init]) {
        [self setMessage:message style:style parentView:parentView indicatorSize:size fontSize: fontSize dismissWhenClick: dismissWhenClick];
    }
    return self;
}

- (void)updateProgress:(CGFloat)progress{
    if (self.style == JHProgressHUDStyleValue2 || self.style == JHProgressHUDStyleValue4) {
        self.indicator.doubleValue = progress;
    }
}
- (void)updateMessage:(NSString *)message{
    self.text.stringValue = message;
}

#pragma mark - 私有方法

+ (instancetype)shareHUD{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hud = [[JHProgressHUD alloc] init];
    });
    return _hud;
}

- (void)show{
    self.showing = YES;
    self.blackBackGroundMask.alphaValue = 0;
    [self.parentView addSubview: self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    [self.indicator startAnimation: self];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 1;
        self.blackBackGroundMask.animator.alphaValue = 1;
    } completionHandler:nil];
    
}

- (void)disMiss{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 1;
        self.blackBackGroundMask.animator.alphaValue = 0;
    } completionHandler:^{
        self.showing = NO;
        [self.indicator stopAnimation: self];
        [self updateProgress:0];
        [self removeFromSuperview];
    }];
}

- (BOOL)isShowing{
    return self.showing;
}

- (void)clickBlackView{
    if (self.dismissWhenClick) [self disMiss];
}

- (void)setMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView indicatorSize:(NSSize)size fontSize:(CGFloat)fontSize dismissWhenClick:(BOOL)dismissWhenClick{
    self.parentView = parentView;
    self.dismissWhenClick = dismissWhenClick;
    self.style = style;
    
    [self addSubview: self.blackBackGroundMask];
    [self.blackBackGroundMask mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    self.indicator.indeterminate = (style == JHProgressHUDStyleValue1 || style == JHProgressHUDStyleValue3);
    
    if (style == JHProgressHUDStyleValue1 || style == JHProgressHUDStyleValue2) {
        self.indicator.style = NSProgressIndicatorSpinningStyle;
    }else{
        self.indicator.style = NSProgressIndicatorBarStyle;
    }
    
    
    [self.blackBackGroundMask addSubview: self.indicator];
    [self.indicator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
    
    [self.blackBackGroundMask addSubview: self.text];
    self.text.stringValue = message;
    self.text.font = [NSFont systemFontOfSize: fontSize];
    [self.text mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.indicator);
        make.top.equalTo(self.indicator.mas_bottom).mas_offset(20);
    }];
}



#pragma mark - 懒加载
- (NSProgressIndicator *)indicator {
    if(_indicator == nil) {
        _indicator = [[NSProgressIndicator alloc] init];
        _indicator.style = NSProgressIndicatorSpinningStyle;
        _indicator.minValue = 0;
        _indicator.maxValue = 1;
    }
    return _indicator;
}

- (NSView *)blackBackGroundMask {
    if(_blackBackGroundMask == nil) {
        _blackBackGroundMask = [[NSView alloc] init];
        [_blackBackGroundMask setWantsLayer: YES];
        [_blackBackGroundMask.layer setBackgroundColor: [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
        [_blackBackGroundMask addGestureRecognizer:[[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(clickBlackView)]];
    }
    return _blackBackGroundMask;
}

- (NSTextField *)text {
	if(_text == nil) {
		_text = [[NSTextField alloc] init];
        _text.editable = NO;
        _text.drawsBackground = NO;
        _text.bordered = NO;
        _text.textColor = [NSColor whiteColor];
	}
	return _text;
}

@end
