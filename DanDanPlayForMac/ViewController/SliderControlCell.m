//
//  SliderControlCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "SliderControlCell.h"
@interface SliderControlCell()
@property (strong, nonatomic) slideBlock block;
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
            self.slider.floatValue = 0.375;
            break;
        case sliderControlStyleSpeed:
            self.title.stringValue = @"速度调节";
            self.slider.floatValue = [UserDefaultManager danMuSpeed] / 100.0;
            break;
        case sliderControlStyleOpacity:
            self.title.stringValue = @"弹幕透明度";
            self.slider.floatValue = [UserDefaultManager danMuOpacity] / 100.0;
            break;
        default:
            break;
    }
}

- (void)clickSlider:(NSSlider *)slider{
    if (self.block) {
        switch (self.style) {
            case sliderControlStyleFontSize:
            {
                float value = slider.floatValue * 1.6 + 0.4;
                self.block(value);
                self.valueLabel.stringValue = [NSString stringWithFormat:@"%.1f", value];
                break;
            }
            case sliderControlStyleSpeed:
            {
                float value = slider.floatValue * 2.9 + 0.1;
                self.block(value);
                self.valueLabel.stringValue = [NSString stringWithFormat:@"%.1f", value];
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
