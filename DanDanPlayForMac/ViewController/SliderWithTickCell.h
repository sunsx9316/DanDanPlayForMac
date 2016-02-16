//
//  SliderWithTickCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef NS_ENUM(NSUInteger, sliderWithTickCellStyle) {
    sliderWithTickCellStyleSpeed,
    sliderWithTickCellStyleOpacity
};
@interface SliderWithTickCell : NSView
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTextField *detailTextField;
- (void)setUpDefauleValueWithStyle:(sliderWithTickCellStyle)style;
@end
