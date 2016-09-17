//
//  PlayHistoryCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/25.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OtherOnlyButtonCell.h"
@interface OtherOnlyButtonCell()
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSButton *clickButton;

@end

@implementation OtherOnlyButtonCell
- (IBAction)clickClearPlayHistoryButton:(NSButton *)sender {
    if (self.clickButtonCallBackBlock) {
        self.clickButtonCallBackBlock();
    }
}

- (void)setWithTitle:(NSString *)title info:(NSString *)info buttonText:(NSString *)buttonText{
    self.titleTextField.text = title;
    self.infoTextField.text = info;
    self.clickButton.text = buttonText;
}

@end
