//
//  SliderControlCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "SliderControlCell.h"
@interface SliderControlCell()
@property (copy, nonatomic) slideBlock block;
@property (strong, nonatomic) NSTextField *title;
@property (strong, nonatomic) NSTextField *valueLabel;
@property (strong, nonatomic) NSSlider *slider;
@property (assign, nonatomic) sliderControlStyle style;
@end

@implementation SliderControlCell
- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview: self.title];
        [self addSubview: self.valueLabel];
        [self addSubview: self.slider];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDanmakuValue:) name:@"CHANGE_DANMAKU_VALUE" object:nil];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(10);
        }];
        
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title.mas_left).mas_offset(10);
            make.top.mas_equalTo(self.title.mas_bottom).mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
        
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.left.mas_equalTo(self.slider.mas_right).mas_offset(10);
            make.centerY.equalTo(self.slider);
        }];
    }
    return self;
}

- (void)setWithBlock:(slideBlock)block sliderControlStyle:(sliderControlStyle)style{
    self.style = style;
    self.block = block;
    switch (style) {
        case sliderControlStyleFontSize:
            self.title.stringValue = @"字体缩放";
            self.slider.minValue = 1;
            self.slider.maxValue = 100;
            self.slider.floatValue = [UserDefaultManager danMuFont].pointSize;
            break;
        case sliderControlStyleSpeed:
            self.title.stringValue = @"速度调节";
            self.slider.minValue = 0.1;
            self.slider.maxValue = 3.0;
            self.slider.floatValue = [UserDefaultManager danMuSpeed];
            break;
        case sliderControlStyleOpacity:
            self.title.stringValue = @"弹幕透明度";
            self.slider.minValue = 0;
            self.slider.maxValue = 1.0;
            self.slider.floatValue = [UserDefaultManager danMuOpacity];
            break;
        default:
            break;
    }
    [self clickSlider:self.slider];
}

- (void)clickSlider:(NSSlider *)slider{
    if (self.block) {
        switch (self.style) {
            case sliderControlStyleFontSize:
            {
                float value = slider.floatValue;
                self.block(value);
                self.valueLabel.stringValue = [NSString stringWithFormat:@"%.1f", value / 25];
                break;
            }
            case sliderControlStyleSpeed:
            {
                float value = slider.floatValue;
                self.block(value);
                if (value == 3.0) {
                    self.valueLabel.textColor = [NSColor redColor];
                }else{
                    self.valueLabel.textColor = [NSColor whiteColor];
                }
                self.valueLabel.stringValue = [NSString stringWithFormat:@"%.1f倍速", value];
                break;
            }
            case sliderControlStyleOpacity:{
                self.block(slider.floatValue);
                self.valueLabel.stringValue = [NSString stringWithFormat:@"%.1f", slider.floatValue];
                break;
            }
            default:
                break;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 私有方法
- (void)changeDanmakuValue:(NSNotification *)sender{
    if ([sender.userInfo[@"type"] unsignedIntegerValue] == self.style) {
        self.slider.floatValue = [sender.userInfo[@"value"] floatValue];
        [self clickSlider:self.slider];
    }
}

#pragma mark - 懒加载
- (NSSlider *)slider {
	if(_slider == nil) {
		_slider = [[NSSlider alloc] init];
        _slider.continuous = NO;
        [_slider setAction:@selector(clickSlider:)];
        [_slider setTarget: self];
	}
	return _slider;
}

- (NSTextField *)valueLabel {
	if(_valueLabel == nil) {
		_valueLabel = [[NSTextField alloc] init];
        _valueLabel.stringValue = @"1.0";
        _valueLabel.editable = NO;
        _valueLabel.bordered = NO;
        _valueLabel.drawsBackground = NO;
        [_valueLabel setTextColor: [NSColor whiteColor]];
	}
	return _valueLabel;
}

- (NSTextField *)title {
	if(_title == nil) {
		_title = [[NSTextField alloc] init];
        _title.editable = NO;
        _title.bordered = NO;
        _title.drawsBackground = NO;
        [_title setTextColor: [NSColor whiteColor]];
	}
	return _title;
}

@end
