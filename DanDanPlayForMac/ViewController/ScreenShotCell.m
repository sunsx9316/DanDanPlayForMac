//
//  ScreenShotCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ScreenShotCell.h"
#import "NSOpenPanel+Tools.h"

@interface ScreenShotCell()
@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSPopUpButton *screenShotTypeButton;

@end

@implementation ScreenShotCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.screenShotTypeButton selectItemAtIndex: [UserDefaultManager defaultScreenShotType]];
    self.pathTextField.placeholderString = [UserDefaultManager screenShotPath];
}

- (IBAction)clickResetButton:(NSButton *)sender {
    [UserDefaultManager setScreenShotPath: nil];
    self.pathTextField.placeholderString = [UserDefaultManager screenShotPath];
}
- (IBAction)clickChoosePathButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel chooseDirectoriesPanelWithTitle:@"选取截图目录" defaultURL:[NSURL fileURLWithPath:[UserDefaultManager screenShotPath]]];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            self.pathTextField.placeholderString = openPanel.URL.path;
            [UserDefaultManager setScreenShotPath: openPanel.URL.path];
        }
    }];

}
- (IBAction)clickSaveImgTypeButton:(NSPopUpButton *)sender {
    [UserDefaultManager setDefaultScreenShotType:[sender indexOfSelectedItem]];
}

@end
