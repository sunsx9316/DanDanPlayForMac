//
//  PlayerHUDMessageView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "HUDMessageView.h"
#import <POP.h>
#import "NSView+Tools.h"
#import "Masonry.h"

@interface HUDMessageView()
@property (strong, nonatomic) NSTextField *textField;
@property (strong, nonatomic) NSImageView *bgImgView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HUDMessageView
- (instancetype)init {
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self config];
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)layout {
    self.frame = CGRectMake(0, 0, self.textField.frame.size.width + 15, self.textField.frame.size.height + 15);
    self.center = self.superview.center;
    [super layout];
}

- (void)showHUD {
    [self showHUDWithAnimateTime:0.4];
}

- (void)showHUDWithAnimateTime:(NSTimeInterval)time {
    [self.timer invalidate];
    if (!self.superview) {
        [NSApp.keyWindow.contentViewController.view addSubview:self];
    }
    self.center = self.superview.center;
    
    POPBasicAnimation *anima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    anima.toValue = @1;
    anima.duration = time;
    [anima setCompletionBlock:^(POPAnimation *anima, BOOL finished) {
        if (finished) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideHUD) userInfo:nil repeats:NO];
        }
    }];
    
    [self.layer pop_addAnimation:anima forKey:@"HUD_message_view_show"];
}

- (void)hideHUD {
    POPBasicAnimation *anima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    anima.toValue = @0;
    [anima setCompletionBlock:^(POPAnimation *anima, BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [self.layer pop_addAnimation:anima forKey:@"HUD_message_view_hide"];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize {
    [self setNeedsUpdateConstraints:YES];
    [self updateConstraintsForSubtreeIfNeeded];
    
    [super resizeWithOldSuperviewSize:oldSize];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.stringValue = text;
    [self.textField sizeToFit];
    [self setNeedsUpdateConstraints:YES];
    [self updateConstraintsForSubtreeIfNeeded];
}

#pragma mark - 私有方法
- (void)config {
    self.wantsLayer = YES;
    self.layer.opacity = 0;
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.center.equalTo(self.textField);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

#pragma mark - 懒加载
- (NSTextField *)textField {
    if(_textField == nil) {
        _textField = [[NSTextField alloc] init];
        _textField.bordered = NO;
        _textField.drawsBackground = NO;
        _textField.editable = NO;
        _textField.textColor = [NSColor whiteColor];
        _textField.font = [NSFont systemFontOfSize: 17];
        [self addSubview: _textField];
    }
    return _textField;
}

- (NSImageView *)bgImgView {
    if(_bgImgView == nil) {
        _bgImgView = [[NSImageView alloc] init];
        _bgImgView.image = [NSImage imageNamed:@"HUD_message"];
        _bgImgView.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview: _bgImgView];
    }
    return _bgImgView;
}

@end
