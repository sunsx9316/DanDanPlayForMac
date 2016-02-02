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
@property (strong, nonatomic) NSView *blackBackGroundMask;
@property (strong, nonatomic) NSProgressIndicator *indicator;
@property (strong, nonatomic) NSView *parentView;
@property (strong, nonatomic) NSTextField *text;
@property (assign, nonatomic) BOOL dismissWhenClick;
@end

@implementation JHProgressHUD
+ (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView dismissWhenClick:(BOOL)dismissWhenClick{
    JHProgressHUD *hud = [self shareHUD];
    [hud setMessage:message style:style parentView:parentView dismissWhenClick: dismissWhenClick];
    [hud show];
}

+ (void)showWithMessage:(NSString *)message parentView:(NSView *)parentView{
    [self showWithMessage:message style:value1 parentView:parentView dismissWhenClick: YES];
}

+ (void)disMiss{
    [[self shareHUD] disMiss];
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
    [self.parentView addSubview: self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    [self.indicator startAnimation: self];
}

- (void)disMiss{
    [self.indicator stopAnimation: self];
    [self removeFromSuperview];
}

- (void)clickBlackView{
    if (self.dismissWhenClick) [self disMiss];
}

- (void)setMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView dismissWhenClick:(BOOL)dismissWhenClick{
    self.parentView = parentView;
    self.dismissWhenClick = dismissWhenClick;
    
    [self addSubview: self.blackBackGroundMask];
    [self.blackBackGroundMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    [self.blackBackGroundMask addSubview: self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.blackBackGroundMask addSubview: self.text];
    self.text.stringValue = message;
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.indicator);
        make.top.equalTo(self.indicator.mas_bottom).mas_offset(20);
    }];
}

#pragma mark - 懒加载
- (NSProgressIndicator *)indicator {
    if(_indicator == nil) {
        _indicator = [[NSProgressIndicator alloc] init];
        _indicator.style = NSProgressIndicatorSpinningStyle;
        
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
