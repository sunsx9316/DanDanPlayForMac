//
//  HideDanMuAndCloseCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "HideDanMuAndCloseCell.h"
#import "NSButton+Tools.h"
@interface HideDanMuAndCloseCell()
@property (strong, nonatomic) NSButton *hideScrollDanMuButton;
@property (strong, nonatomic) NSButton *hideTopDanMuButton;
@property (strong, nonatomic) NSButton *hideBottomDanMuButton;
@property (strong, nonatomic) NSTextField *title;
@end

@implementation HideDanMuAndCloseCell
- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview: self.title];
        [self addSubview: self.hideScrollDanMuButton];
        [self addSubview: self.hideTopDanMuButton];
        [self addSubview: self.hideBottomDanMuButton];
        
        
        [self.hideScrollDanMuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
        
        [self.hideTopDanMuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(self.hideScrollDanMuButton);
        }];
        
        [self.hideBottomDanMuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(self.hideScrollDanMuButton);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hideScrollDanMuButton);
            make.bottom.equalTo(self.hideScrollDanMuButton.mas_top).mas_offset(-10);
            make.top.mas_offset(5);
        }];
    }
    return self;
}

- (void)clickHideButton:(NSButton *)button{
    if (self.selectBlock) {
        self.selectBlock(button.tag, button.state);
    }
}


#pragma mark - 懒加载

- (NSButton *)hideScrollDanMuButton {
	if(_hideScrollDanMuButton == nil) {
		_hideScrollDanMuButton = [[NSButton alloc] init];
        _hideScrollDanMuButton.title = @"滚动弹幕";
        _hideScrollDanMuButton.bordered = NO;
        _hideScrollDanMuButton.tag = 10;
        [_hideScrollDanMuButton setButtonType: NSSwitchButton];
        [_hideScrollDanMuButton setTitleColor: [NSColor whiteColor]];
        [_hideScrollDanMuButton setTarget: self];
        [_hideScrollDanMuButton setAction:@selector(clickHideButton:)];
	}
	return _hideScrollDanMuButton;
}

- (NSButton *)hideTopDanMuButton {
	if(_hideTopDanMuButton == nil) {
		_hideTopDanMuButton = [[NSButton alloc] init];
        _hideTopDanMuButton.title = @"顶部弹幕";
        _hideTopDanMuButton.bordered = NO;
        _hideTopDanMuButton.tag = 101;
        [_hideTopDanMuButton setButtonType: NSSwitchButton];
        [_hideTopDanMuButton setTitleColor: [NSColor whiteColor]];
        [_hideTopDanMuButton setTarget: self];
        [_hideTopDanMuButton setAction:@selector(clickHideButton:)];
	}
	return _hideTopDanMuButton;
}

- (NSButton *)hideBottomDanMuButton {
	if(_hideBottomDanMuButton == nil) {
		_hideBottomDanMuButton = [[NSButton alloc] init];
        _hideBottomDanMuButton.title = @"底部弹幕";
        _hideBottomDanMuButton.bordered = NO;
        _hideBottomDanMuButton.tag = 100;
        [_hideBottomDanMuButton setButtonType: NSSwitchButton];
        [_hideBottomDanMuButton setTitleColor: [NSColor whiteColor]];
        [_hideBottomDanMuButton setTarget: self];
        [_hideBottomDanMuButton setAction:@selector(clickHideButton:)];
	}
	return _hideBottomDanMuButton;
}

- (NSTextField *)title {
	if(_title == nil) {
		_title = [[NSTextField alloc] init];
        _title.text = @"弹幕屏蔽";
        _title.editable = NO;
        _title.bordered = NO;
        _title.drawsBackground = NO;
        [_title setTextColor: [NSColor whiteColor]];
	}
	return _title;
}

@end
