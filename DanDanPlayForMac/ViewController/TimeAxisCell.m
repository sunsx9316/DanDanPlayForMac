//
//  TimeAxisCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "TimeAxisCell.h"
#import <DDPCategory/NSString+DDPTools.h>

@interface TimeAxisCell()
@property (strong, nonatomic) NSButton *plusOneButton;
@property (strong, nonatomic) NSButton *subtractOneButton;
@property (strong, nonatomic) NSButton *resetButton;
@property (strong, nonatomic) NSTextField *title;
@property (strong, nonatomic) NSTextField *inputTextField;
@end

@implementation TimeAxisCell
{
    //记录原来的时间偏移量
    NSInteger _originalOffsetTime;
}
- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        
        [self addSubview: self.title];
        [self addSubview: self.plusOneButton];
        [self addSubview: self.subtractOneButton];
        [self addSubview: self.inputTextField];
        [self addSubview: self.resetButton];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(10);
        }];
        
        [self.subtractOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.top.equalTo(self.title.mas_bottom).mas_offset(10);
        }];
        
        [self.plusOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(self.subtractOneButton);
        }];

        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.plusOneButton);
            make.right.equalTo(self.plusOneButton.mas_left).mas_offset(-20);
            make.left.equalTo(self.subtractOneButton.mas_right).mas_offset(20);
        }];
        
        [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.subtractOneButton);
            make.right.equalTo(self.plusOneButton);
            make.top.equalTo(self.subtractOneButton.mas_bottom).mas_offset(20);
        }];
        
    }
    return self;
}

#pragma mark - 私有方法
- (void)clickInputTextField:(NSTextField *)sender {
    NSString *str = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isPureInt]) {
        sender.text = str;
        _originalOffsetTime = str.integerValue;
        if (self.timeOffsetBlock) {
            self.timeOffsetBlock(_originalOffsetTime);
        }
    }
    else {
        sender.text = [NSString stringWithFormat:@"%ld", _originalOffsetTime];
    }
}

- (void)clickButton:(NSButton *)button{
    if (self.timeOffsetBlock) {
        NSInteger num = button.tag - 100;
        if (num == 0) {
            _originalOffsetTime = 0;
        }
        else {
            _originalOffsetTime += num;
        }
        self.inputTextField.stringValue = [NSString stringWithFormat:@"%ld", _originalOffsetTime];
        self.timeOffsetBlock(_originalOffsetTime);
    }
}

#pragma mark - 懒加载

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

- (NSButton *)subtractOneButton {
	if(_subtractOneButton == nil) {
		_subtractOneButton = [[NSButton alloc] init];
        [_subtractOneButton setBezelStyle: NSInlineBezelStyle];
        [_subtractOneButton setTarget: self];
        [_subtractOneButton setAction: @selector(clickButton:)];
        _subtractOneButton.title = @"-1秒";
        _subtractOneButton.tag = 99;
	}
	return _subtractOneButton;
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
        _title.text = @"弹幕时间轴";
        _title.editable = NO;
        _title.bordered = NO;
        _title.drawsBackground = NO;
        [_title setTextColor: [NSColor whiteColor]];
	}
	return _title;
}


- (NSTextField *)inputTextField {
	if(_inputTextField == nil) {
		_inputTextField = [[NSTextField alloc] init];
        _inputTextField.alignment = NSTextAlignmentCenter;
        _inputTextField.text = @"0";
        _inputTextField.editable = YES;
        _inputTextField.target = self;
        _inputTextField.placeholderString = @"输入偏移的时间";
        _inputTextField.action = @selector(clickInputTextField:);
	}
	return _inputTextField;
}

@end
