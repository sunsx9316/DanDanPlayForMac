//
//  ScreenShotCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ScreenShotCell.h"
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
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:[UserDefaultManager screenShotPath]]];
    [openPanel setTitle:@"选取截图目录"];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection: NO];
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
