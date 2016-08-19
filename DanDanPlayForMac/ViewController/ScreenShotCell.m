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
    [self.screenShotTypeButton selectItemAtIndex: [UserDefaultManager shareUserDefaultManager].defaultScreenShotType];
    self.pathTextField.placeholderString = [UserDefaultManager shareUserDefaultManager].screenShotPath;
}

- (IBAction)clickResetButton:(NSButton *)sender {
    [UserDefaultManager shareUserDefaultManager].screenShotPath = nil;
    self.pathTextField.placeholderString = [UserDefaultManager shareUserDefaultManager].screenShotPath;
}

- (IBAction)clickChoosePathButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel chooseDirectoriesPanelWithTitle:@"选取截图目录" defaultURL:[NSURL fileURLWithPath:[UserDefaultManager shareUserDefaultManager].screenShotPath]];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            NSString *path = openPanel.URL.path;
            self.pathTextField.placeholderString = path;
            [UserDefaultManager shareUserDefaultManager].screenShotPath = path;
        }
    }];
}

- (IBAction)clickSaveImgTypeButton:(NSPopUpButton *)sender {
    [UserDefaultManager shareUserDefaultManager].defaultScreenShotType = [sender indexOfSelectedItem];
}

@end
