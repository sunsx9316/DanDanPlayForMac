//
//  PlayLastWatchVideoTimeView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerLastWatchVideoTimeView.h"
#import "POPMasBaseAnimation.h"

@interface PlayerLastWatchVideoTimeView()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PlayerLastWatchVideoTimeView
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

- (IBAction)clickContinusButton:(NSButton *)sender {
    if (self.continusBlock) {
        self.continusBlock(self.time);
    }
    [self dismiss];
}

- (IBAction)clickCloseButton:(NSButton *)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
    [self dismiss];
}

- (void)show {
    [self.timer invalidate];
    self.alphaValue = 1;
    if (!self.superview) {
        [NSApp.keyWindow.contentViewController.view addSubview:self];
    }
    
    POPMasBaseAnimation *animate = [POPMasBaseAnimation animationWithPropertyType:POPMasAnimationTypeLeft];
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
    [self pop_addAnimation:animate forKey:@"last_time_view_show_anime"];
}

- (void)dismiss {
    [self.timer invalidate];
    POPMasBaseAnimation *animate = [POPMasBaseAnimation animationWithPropertyType:POPMasAnimationTypeLeft];
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
    
    [self pop_addAnimation:animate forKey:@"last_time_view_hide_anime"];
}

@end
