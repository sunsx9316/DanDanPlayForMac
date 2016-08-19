//
//  CaptionsProtectAreaCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "CaptionsProtectAreaCell.h"
@interface CaptionsProtectAreaCell()
@property (weak) IBOutlet NSButton *OKButton;

@end

@implementation CaptionsProtectAreaCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.OKButton.state = [UserDefaultManager shareUserDefaultManager].turnOnCaptionsProtectArea;
}

- (IBAction)clickButton:(NSButton *)sender {
    [UserDefaultManager shareUserDefaultManager].turnOnCaptionsProtectArea = sender.state;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_CAPTIONS_PROTECT_AREA" object:nil];
}

@end
