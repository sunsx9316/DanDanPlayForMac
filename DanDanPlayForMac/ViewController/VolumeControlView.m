//
//  volumeControlView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VolumeControlView.h"
@interface VolumeControlView()
@property (strong, nonatomic) NSImageView *imgView;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@end
@implementation VolumeControlView

- (instancetype)init{
    if (self = [super init]) {
        [self addTrackingArea:self.trackingArea];
        [self addSubview:self.imgView];
        [self addSubview:self.volumeSlider];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(5);
            make.right.bottom.mas_offset(-5);
        }];
    }
    return self;
}

- (void)mouseExited:(NSEvent *)theEvent{
    [self hide];
}

- (void)show{
    self.animator.hidden = NO;
}
- (void)hide{
    self.animator.hidden = YES;
}

- (void)dealloc{
    [self removeTrackingArea:self.trackingArea];
}

#pragma mark - 懒加载
- (NSImageView *)imgView {
	if(_imgView == nil) {
		_imgView = [[NSImageView alloc] init];
        _imgView.imageScaling = NSImageScaleAxesIndependently;
        _imgView.image = [NSImage imageNamed:@"HUD_panel"];
        _imgView.image.capInsets = NSEdgeInsetsMake(10, 10, 10, 10);
	}
	return _imgView;
}

- (NSSlider *)volumeSlider {
	if(_volumeSlider == nil) {
		_volumeSlider = [[NSSlider alloc] init];
        _volumeSlider.minValue = 0;
        _volumeSlider.maxValue = 200;
        _volumeSlider.floatValue = 100;
        [_volumeSlider rotateByAngle:-90];
	}
	return _volumeSlider;
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

@end
