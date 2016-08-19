//
//  DanMuFastMatchCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/17.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuFastMatchCell.h"
@interface DanMuFastMatchCell()
@property (weak) IBOutlet NSButton *fastMatchButton;
@end

@implementation DanMuFastMatchCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.fastMatchButton.state = [UserDefaultManager shareUserDefaultManager].turnOnFastMatch;
}

- (IBAction)clickButton:(NSButton *)sender {
    [UserDefaultManager shareUserDefaultManager].turnOnFastMatch = sender.state;
}

@end
