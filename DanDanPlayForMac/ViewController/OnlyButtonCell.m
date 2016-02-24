//
//  OnlyButtonCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OnlyButtonCell.h"
@interface OnlyButtonCell()
@property (copy, nonatomic) buttonDownBlock block;

@end

@implementation OnlyButtonCell
- (void)setWithBlock:(buttonDownBlock)block{
    self.block = block;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview: self.button];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(self).mas_offset(-20);
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)clickButton{
    if (self.block) {
        self.block();
    }
}

#pragma mark - 懒加载
- (NSButton *)button {
	if(_button == nil) {
		_button = [[NSButton alloc] init];
        [_button setBezelStyle: NSRoundedBezelStyle];
        [_button setTarget: self];
        [_button setAction: @selector(clickButton)];
	}
	return _button;
}

@end
