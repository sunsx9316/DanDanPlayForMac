//
//  TimeAxisCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "TimeAxisCell.h"
@interface TimeAxisCell()
@property (strong, nonatomic) NSButton *plusOneButton;
@property (strong, nonatomic) NSButton *plusFiveButton;
@property (strong, nonatomic) NSButton *plusTenButton;
@property (strong, nonatomic) NSButton *subtractOneButton;
@property (strong, nonatomic) NSButton *subtractFiveButton;
@property (strong, nonatomic) NSButton *subtractTenButton;
@property (strong, nonatomic) NSButton *resetButton;
@property (strong, nonatomic) NSTextField *title;
@property (copy, nonatomic) timeOffsetBlock block;
@end

@implementation TimeAxisCell
- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview: self.title];
        [self addSubview: self.plusOneButton];
        [self addSubview: self.plusFiveButton];
        [self addSubview: self.plusTenButton];
        [self addSubview: self.subtractOneButton];
        [self addSubview: self.subtractFiveButton];
        [self addSubview: self.subtractTenButton];
        [self addSubview: self.resetButton];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(10);
        }];
        
        [self.plusOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.top.equalTo(self.title.mas_bottom).mas_offset(10);
        }];
        
        [self.plusFiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(self.plusOneButton);
        }];
        
        [self.plusTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(self.plusFiveButton);
        }];
        
        [self.subtractOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.plusOneButton);
            make.top.equalTo(self.plusOneButton.mas_bottom).mas_offset(10);
        }];
        
        [self.subtractFiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.plusFiveButton);
            make.centerY.equalTo(self.subtractOneButton);
        }];
        
        [self.subtractTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(self.subtractFiveButton);
        }];
        
        [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.plusOneButton);
            make.right.equalTo(self.plusTenButton);
            make.top.equalTo(self.subtractOneButton.mas_bottom).mas_offset(10);
        }];
    }
    return self;
}


- (void)setWithBlock:(timeOffsetBlock)block{
    self.block = block;
}

- (void)clickButton:(NSButton *)button{
    if (self.block) {
        self.block(button.tag > 0?button.tag - 100:button.tag + 100);
    }
}

- (NSButton *)plusOneButton {
	if(_plusOneButton == nil) {
		_plusOneButton = [[NSButton alloc] init];
        [_plusOneButton setBezelStyle: NSInlineBezelStyle];
        [_plusOneButton setTarget: self];
        [_plusOneButton setAction: @selector(clickButton:)];
        _plusOneButton.title = @"+1秒";
        _plusOneButton.tag = 101;
	}
	return _plusOneButton;
}

- (NSButton *)plusFiveButton {
	if(_plusFiveButton == nil) {
		_plusFiveButton = [[NSButton alloc] init];
        [_plusFiveButton setBezelStyle: NSInlineBezelStyle];
        [_plusFiveButton setTarget: self];
        [_plusFiveButton setAction: @selector(clickButton:)];
        _plusFiveButton.title = @"+5秒";
        _plusFiveButton.tag = 105;
	}
	return _plusFiveButton;
}

- (NSButton *)plusTenButton {
	if(_plusTenButton == nil) {
		_plusTenButton = [[NSButton alloc] init];
        [_plusTenButton setBezelStyle: NSInlineBezelStyle];
        [_plusTenButton setTarget: self];
        [_plusTenButton setAction: @selector(clickButton:)];
        _plusTenButton.title = @"+10秒";
        _plusTenButton.tag = 110;
	}
	return _plusTenButton;
}

- (NSButton *)subtractOneButton {
	if(_subtractOneButton == nil) {
		_subtractOneButton = [[NSButton alloc] init];
        [_subtractOneButton setBezelStyle: NSInlineBezelStyle];
        [_subtractOneButton setTarget: self];
        [_subtractOneButton setAction: @selector(clickButton:)];
        _subtractOneButton.title = @"-1秒";
        _subtractOneButton.tag = -101;
	}
	return _subtractOneButton;
}

- (NSButton *)subtractFiveButton {
	if(_subtractFiveButton == nil) {
		_subtractFiveButton = [[NSButton alloc] init];
        [_subtractFiveButton setBezelStyle: NSInlineBezelStyle];
        [_subtractFiveButton setTarget: self];
        [_subtractFiveButton setAction: @selector(clickButton:)];
        _subtractFiveButton.title = @"-5秒";
        _subtractFiveButton.tag = -105;
	}
	return _subtractFiveButton;
}

- (NSButton *)subtractTenButton {
	if(_subtractTenButton == nil) {
		_subtractTenButton = [[NSButton alloc] init];
        [_subtractTenButton setBezelStyle: NSInlineBezelStyle];
        [_subtractTenButton setTarget: self];
        [_subtractTenButton setAction: @selector(clickButton:)];
        _subtractTenButton.title = @"-10秒";
        _subtractTenButton.tag = -110;
	}
	return _subtractTenButton;
}

- (NSButton *)resetButton {
    if(_resetButton == nil) {
        _resetButton = [[NSButton alloc] init];
        [_resetButton setBezelStyle: NSInlineBezelStyle];
        [_resetButton setTarget: self];
        [_resetButton setAction: @selector(clickButton:)];
        _resetButton.title = @"重置时间";
        _resetButton.tag = 100;
    }
    return _resetButton;
}

- (NSTextField *)title {
	if(_title == nil) {
		_title = [[NSTextField alloc] init];
        _title.stringValue = @"弹幕时间轴";
        _title.editable = NO;
        _title.bordered = NO;
        _title.drawsBackground = NO;
        [_title setTextColor: [NSColor whiteColor]];
	}
	return _title;
}


@end
