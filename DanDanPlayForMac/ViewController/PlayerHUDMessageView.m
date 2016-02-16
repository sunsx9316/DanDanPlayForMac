//
//  PlayerHUDMessageView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerHUDMessageView.h"
@interface PlayerHUDMessageView()
@property (strong, nonatomic) NSImageView *bgImg;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PlayerHUDMessageView
- (instancetype)init{
    if (self = [super init]) {
        self.hidden = YES;
    }
    return self;
}

- (void)showHUD{
    [self.timer invalidate];
    self.animator.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideHUD) userInfo:nil repeats:NO];
}
- (void)hideHUD{
    self.animator.hidden = YES;
}

- (void)dealloc{
    [self.timer invalidate];
}

#pragma mark - 懒加载
- (NSTextField *)text {
    if(_text == nil) {
        _text = [[NSTextField alloc] init];
        _text.bordered = NO;
        _text.drawsBackground = NO;
        _text.editable = NO;
        _text.textColor = [NSColor whiteColor];
        _text.font = [NSFont systemFontOfSize: 20];
        [self addSubview: _text positioned:NSWindowAbove relativeTo:self.bgImg];
        [_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.height.lessThanOrEqualTo(self.bgImg);
        }];
    }
    return _text;
}

- (NSImageView *)bgImg {
	if(_bgImg == nil) {
		_bgImg = [[NSImageView alloc] init];
        _bgImg.image = [NSImage imageNamed:@"HUDPanel"];
        _bgImg.imageScaling = NSImageScaleProportionallyUpOrDown;
        [self addSubview: _bgImg];
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
	}
	return _bgImg;
}

@end
