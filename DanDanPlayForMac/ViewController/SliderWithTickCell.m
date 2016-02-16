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
            self.slider.floatValue = [UserDefaultManager danMuSpeed];
            
            [self clickSlider: self.slider];
            break;
        }
        case sliderWithTickCellStyleOpacity:
        {
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
            float value = sender.floatValue * 0.029 + 0.1;
            if (value == 3.0) {
                [self.valueTextField setTextColor: [NSColor redColor]];
            }else{
                [self.valueTextField setTextColor: [NSColor textColor]];
            }
            self.valueTextField.stringValue = [NSString stringWithFormat:@"%.1f倍速", value];
            [UserDefaultManager setDanMuSpeed: sender.floatValue];
            break;
        }
        case sliderWithTickCellStyleOpacity:
        {
            float value = sender.floatValue;
            self.valueTextField.stringValue = [NSString stringWithFormat:@"%.1f%%", value];
            [UserDefaultManager setDanMuOpacity: value];
            break;
        }
        default:
            break;
    }
}


@end
