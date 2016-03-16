//
//  PlayLastWatchVideoTimeView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayLastWatchVideoTimeView.h"
@interface PlayLastWatchVideoTimeView()
@property (copy, nonatomic) continusBlock cBlock;
@property (copy, nonatomic) closeViewBlock cVBlock;
@property (strong, nonatomic) NSTimer *timer;
@end
@implementation PlayLastWatchVideoTimeView
- (IBAction)clickContinusButton:(NSButton *)sender {
    if (self.cBlock) {
        self.cBlock(self.time);
    }
    [self hide];
}
- (IBAction)clickCloseButton:(NSButton *)sender {
    if (self.cVBlock) {
        self.cVBlock();
    }
    [self hide];
}

- (void)setContinusBlock:(continusBlock)block{
    self.cBlock = block;
}
- (void)setCloseViewBlock:(closeViewBlock)block{
    self.cVBlock = block;
}


- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
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
