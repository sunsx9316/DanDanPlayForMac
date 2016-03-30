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
    self.titleTextField.stringValue = title.length ? title : @"";
    self.infoTextField.stringValue = info.length ? info : @"";
    self.clickButton.title = buttonText.length ? buttonText : @"";
}

@end
