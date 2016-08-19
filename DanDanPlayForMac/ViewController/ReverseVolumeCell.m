//
//  ReverseVolumeCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ReverseVolumeCell.h"
#import "JHSwichButton.h"

@interface ReverseVolumeCell ()
@property (weak) IBOutlet JHSwichButton *switchButton;
@end


@implementation ReverseVolumeCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.switchButton addTarget:self action:@selector(clickButton:)];
    self.switchButton.openColor = MAIN_COLOR;
    self.switchButton.status = [UserDefaultManager shareUserDefaultManager].reverseVolumeScroll;
}

- (void)clickButton:(JHSwichButton *)button {
    [UserDefaultManager shareUserDefaultManager].reverseVolumeScroll = button.status;
}

@end
