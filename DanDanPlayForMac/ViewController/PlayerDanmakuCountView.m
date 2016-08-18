//
//  PlayerDanmakuCountView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerDanmakuCountView.h"
#import "POPMasAnimation.h"

@interface PlayerDanmakuCountView ()
@property (weak) IBOutlet NSTextField *danmaukuCountTextField;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PlayerDanmakuCountView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:YES];
        self.layer.backgroundColor = RGBAColor(0, 0, 0, 0.5).CGColor;
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)setDanmakuCount:(NSUInteger)danmakuCount {
    _danmakuCount = danmakuCount;
    if (_danmakuCount > 10000) {
        self.danmaukuCountTextField.stringValue = [NSString stringWithFormat:@"%.2f万", _danmakuCount / 10000.0];
    }
    else {
        self.danmaukuCountTextField.integerValue = danmakuCount;
    }
}

- (IBAction)clickCloseButton:(NSButton *)sender {
    if (self.touchCloseButtonCallBack) {
        self.touchCloseButtonCallBack();
    }
    [self dismiss];
}

- (void)show {
    self.alphaValue = 1;
    [self.timer invalidate];
    if (!self.superview) {
        [NSApp.keyWindow.contentViewController.view addSubview:self];
    }
    
    POPMasAnimation *animate = [POPMasAnimation animationWithPropertyType:POPMasAnimationTypeLeft];
    animate.fromValue = @(-self.frame.size.width);
    animate.toValue = @0;
    animate.duration = 0.8;
    @weakify(self)
    [animate setCompletionBlock:^(POPAnimation *animate, BOOL finish) {
        @strongify(self)
        if (!self) return;
        
        if (finish) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        }
    }];
    [self pop_addAnimation:animate forKey:@"danmaku_view_show_anime"];
}

- (void)dismiss {
    POPMasAnimation *animate = [POPMasAnimation animationWithPropertyType:POPMasAnimationTypeLeft];
    animate.fromValue = @0;
    animate.toValue = @(-self.frame.size.width);
    animate.duration = 0.8;
    @weakify(self)
    [animate setCompletionBlock:^(POPAnimation *animate, BOOL finish) {
        @strongify(self)
        if (!self) return;
        
        if (finish) {
            self.alphaValue = 0;
        }
    }];
    [self pop_addAnimation:animate forKey:@"danmaku_view_hide_anime"];
}
@end
