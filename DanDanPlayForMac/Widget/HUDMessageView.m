//
//  PlayerHUDMessageView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "HUDMessageView.h"
#import <POP.h>

@interface HUDMessageView()
@property (strong, nonatomic) NSImageView *bgImg;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HUDMessageView
- (instancetype)init{
    if (self = [super init]) {
//        self.hidden = YES;
        self.alphaValue = 0;
        self.frame = CGRectMake(0, 0, 200, 40);
    }
    return self;
}

- (void)showHUD {
    [self.timer invalidate];
    if (!self.superview) {
        [NSApp.keyWindow.contentViewController.view addSubview:self];
    }
    
    self.center = self.superview.center;
//    self.animator.hidden = NO;
    POPBasicAnimation *anima = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlphaValue];
//    anima.beginTime = CACurrentMediaTime();
    anima.toValue = @1;
    [self pop_addAnimation:anima forKey:@"HUD_message_view_show"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideHUD) userInfo:nil repeats:NO];
}

- (void)hideHUD{
    POPBasicAnimation *anima = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlphaValue];
//    anima.beginTime = CACurrentMediaTime();
    anima.toValue = @0;
    [anima setCompletionBlock:^(POPAnimation *anima, BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [self pop_addAnimation:anima forKey:@"HUD_message_view_hide"];
//    self.animator.hidden = YES;
}

- (void)dealloc{
    [self.timer invalidate];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize {
    [super resizeWithOldSuperviewSize:oldSize];
    self.center = self.superview.center;
}

#pragma mark - 懒加载
- (NSTextField *)text {
    if(_text == nil) {
        _text = [[NSTextField alloc] init];
        _text.bordered = NO;
        _text.drawsBackground = NO;
        _text.editable = NO;
        _text.textColor = [NSColor whiteColor];
        _text.font = [NSFont systemFontOfSize: 17];
        [self addSubview: _text positioned:NSWindowAbove relativeTo:self.bgImg];
        [_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _text;
}

- (NSImageView *)bgImg {
	if(_bgImg == nil) {
		_bgImg = [[NSImageView alloc] init];
        _bgImg.image = [NSImage imageNamed:@"HUD_message"];
        _bgImg.imageScaling = NSImageScaleProportionallyUpOrDown;
        [self addSubview: _bgImg];
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
	}
	return _bgImg;
}

@end
