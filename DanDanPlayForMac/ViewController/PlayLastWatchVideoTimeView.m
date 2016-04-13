//
//  PlayLastWatchVideoTimeView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayLastWatchVideoTimeView.h"
@interface PlayLastWatchVideoTimeView()
@property (strong, nonatomic) NSTimer *timer;
@end
@implementation PlayLastWatchVideoTimeView
- (IBAction)clickContinusButton:(NSButton *)sender {
    if (self.continusBlock) {
        self.continusBlock(self.time);
    }
    [self hide];
}
- (IBAction)clickCloseButton:(NSButton *)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
    [self hide];
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:YES];
        self.layer.backgroundColor = RGBAColor(0, 0, 0, 0.5).CGColor;
        [self hide];
    }
    return self;
}

- (void)show{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        self.animator.alphaValue = 1;
    } completionHandler:^{
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }];
}
- (void)hide{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        self.animator.alphaValue = 0;
    } completionHandler:^{
        [self.timer invalidate];
    }];
}
@end
