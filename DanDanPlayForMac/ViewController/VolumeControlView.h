//
//  volumeControlView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VolumeControlView : NSView
@property (strong, nonatomic) NSSlider *volumeSlider;
- (void)show;
- (void)hide;
@end
