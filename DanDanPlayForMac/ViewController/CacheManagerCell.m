//
//  CacheManagerCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "CacheManagerCell.h"
@interface CacheManagerCell()
@property (weak) IBOutlet NSTextField *pathTextField;

@end

@implementation CacheManagerCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.pathTextField.placeholderString = [UserDefaultManager cachePath];
}

- (IBAction)clickClearCacheButton:(NSButton *)sender {
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[UserDefaultManager cachePath] error:&err];
    NSString *errorStr = nil;
    NSString *inforStr = @"";
    if (err) {
        if (err.code == NSFileNoSuchFileError) {
            errorStr = @"(╬ﾟдﾟ)并没有这个文件夹";
            inforStr = @"你想怎样";
        }
        else errorStr = @"清除失败";
    }else{
        errorStr = @"清除成功";
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = errorStr;
    alert.informativeText = inforStr;
    [alert runModal];
}
- (IBAction)clickChangeCachePathButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:@"选取缓存目录"];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection: NO];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            NSString *path = [openPanel.URL.path stringByAppendingPathComponent:@"dandanplay"];
            self.pathTextField.placeholderString = path;
            [UserDefaultManager setCachePath: path];
        }
    }];
}




@end
