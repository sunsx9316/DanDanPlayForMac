//
//  SliderWithTickCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "SliderWithTickCell.h"
@interface SliderWithTickCell()
@property (weak) IBOutlet NSTextField *valueTextField;
@property (weak) IBOutlet NSSlider *slider;
@property (assign, nonatomic) sliderWithTickCellStyle style;
@end

@implementation SliderWithTickCell
- (void)setUpDefauleValueWithStyle:(sliderWithTickCellStyle)style{
    self.style = style;
    switch (style) {
        case sliderWithTickCellStyleSpeed:
        {
            self.slider.minValue = 0.1;
            self.slider.maxValue = 3.0;
            self.slider.floatValue = [UserDefaultManager danMuSpeed];
            
            [self clickSlider: self.slider];
            break;
        }
        case sliderWithTickCellStyleOpacity:
        {
            self.slider.minValue = 0;
            self.slider.maxValue = 1.0;
            self.slider.floatValue = [UserDefaultManager danMuOpacity];
            
            [self clickSlider: self.slider];
            break;
        }
        default:
            break;
    }
}

- (IBAction)clickSlider:(NSSlider *)sender {
    switch (self.style) {
        case sliderWithTickCellStyleSpeed:
        {
            float value = sender.floatValue;
            if (value == 3.0) {
                [self.valueTextField setTextColor: [NSColor redColor]];
            }else{
                [self.valueTextField setTextColor: [NSColor textColor]];
            }
            self.valueTextField.stringValue = [NSString stringWithFormat:@"%.1f倍速", value];
            [UserDefaultManager setDanMuSpeed: sender.floatValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_DANMAKU_VALUE" object:nil userInfo:@{@"value":@(sender.floatValue)}];
            break;
        }
        case sliderWithTickCellStyleOpacity:
        {
            float value = sender.floatValue;
            self.valueTextField.stringValue = [NSString stringWithFormat:@"%.1f%%", value * 100];
            [UserDefaultManager setDanMuOpacity: value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_DANMAKU_VALUE" object:nil userInfo:@{@"value":@(sender.floatValue)}];
            break;
        }
        default:
            break;
    }
}


@end
