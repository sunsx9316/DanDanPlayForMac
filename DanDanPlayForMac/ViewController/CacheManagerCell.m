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
    //标记 下一次启动会执行清空缓存操作
    [UserDefaultManager setClearCache: sender.state];
}
- (IBAction)clickChangeCachePathButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:@"选取缓存目录"];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection: NO];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            self.pathTextField.placeholderString = openPanel.URL.path;
            [UserDefaultManager setCachePath: openPanel.URL.path];
        }
    }];
}




@end
