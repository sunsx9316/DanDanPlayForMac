//
//  AutoUpdateCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/10.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AutoUpdateCell.h"
#import "UpdateNetManager.h"
#import "UpdateViewController.h"
#import "NSAlert+Tools.h"

@interface AutoUpdateCell()
@property (weak) IBOutlet NSTextField *downLoadPathTextField;
@property (weak) IBOutlet NSButton *autoCheakUpdateInfoOnstartButton;

@end

@implementation AutoUpdateCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.downLoadPathTextField.placeholderString = [UserDefaultManager autoDownLoadPath];
    self.autoCheakUpdateInfoOnstartButton.state = [UserDefaultManager cheakDownLoadInfoAtStart];
}

- (IBAction)clickChangeDirectoryButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:@"选取下载目录"];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection: NO];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            NSString *path = openPanel.URL.path;
            self.downLoadPathTextField.placeholderString = path;
            [UserDefaultManager setAutoDownLoadPath:path];
        }
    }];

}
- (IBAction)clickAutoCheakUpdateInfoAtStartButton:(NSButton *)sender {
    [UserDefaultManager setCheakDownLoadInfoAtStart:sender.state];
}

- (IBAction)clickCheakUpdateInfoButton:(NSButton *)sender {
    [UpdateNetManager latestVersionWithCompletionHandler:^(NSString *version, NSString *details, NSString *hash, NSError *error) {
        CGFloat curentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
        //判断当前版本是否比现在版本小
        if (curentVersion < [version floatValue]) {
            NSViewController *vc = NSApp.keyWindow.contentViewController;
            [vc presentViewControllerAsModalWindow:[[UpdateViewController alloc] initWithVersion:version details:details hash:hash]];
        }else{
            [[NSAlert alertWithMessageText:@"作者忙着补番 并没有更新ㄟ( ▔, ▔ )ㄏ" informativeText:nil] runModal];
        }
    }];
}

@end
