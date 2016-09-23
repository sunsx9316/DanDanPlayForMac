//
//  CacheManagerCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "CacheManagerCell.h"
#import "NSAlert+Tools.h"
#import "NSOpenPanel+Tools.h"
#import "NSFileManager+Tools.h"

@interface CacheManagerCell()
@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSTextField *danmakuCacheTextField;
@property (weak) IBOutlet NSTextField *videoTextField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

@implementation CacheManagerCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.pathTextField.placeholderString = [UserDefaultManager shareUserDefaultManager].danmakuCachePath;
    [self.progressIndicator startAnimation:self];
    self.progressIndicator.displayedWhenStopped = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *danmakuCachePath = [UserDefaultManager shareUserDefaultManager].danmakuCachePath;
        NSString *videoCachePath = [UserDefaultManager shareUserDefaultManager].downloadCachePath;
        
        CGFloat danmakuCacheSize = [[NSFileManager defaultManager] folderSizeAtPath:danmakuCachePath excludePaths:@[videoCachePath]];
        CGFloat videoCacheSize = [[NSFileManager defaultManager] folderSizeAtPath:videoCachePath excludePaths:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (danmakuCacheSize < 1024) {
                self.danmakuCacheTextField.text = [NSString stringWithFormat:@"弹幕缓存大小: %.1fk", danmakuCacheSize];
            }
            else {
                self.danmakuCacheTextField.text = [NSString stringWithFormat:@"弹幕缓存大小: %.1fM", danmakuCacheSize / 1024.0];
            }
            
            if (videoCacheSize < 1024) {
                self.videoTextField.text = [NSString stringWithFormat:@"视频缓存大小: %.1fk", videoCacheSize];
            }
            else {
                self.videoTextField.text = [NSString stringWithFormat:@"视频缓存大小: %.1fM", videoCacheSize / 1024.0];
            }
            
            [self.progressIndicator stopAnimation:self];
        });
    });
}

- (IBAction)clickClearCacheButton:(NSButton *)sender {
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[UserDefaultManager shareUserDefaultManager].danmakuCachePath error:&err];
    DanDanPlayMessageModel *model;
    if (err) {
        if (err.code == NSFileNoSuchFileError) {
            model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundCacheDirectories];
        }
        else {
            model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeClearFail];
        }
    }
    else {
        model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeClearSuccess];
        self.danmakuCacheTextField.text = @"弹幕缓存大小: 0.0K";
        self.videoTextField.text = @"视频缓存大小: 0.0K";
    }
    
    [[NSAlert alertWithMessageText:model.message informativeText:model.infomationMessage] runModal];
}

- (IBAction)clickChangeCachePathButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel chooseDirectoriesPanelWithTitle:@"选取缓存目录" defaultURL:[NSURL fileURLWithPath:[UserDefaultManager shareUserDefaultManager].danmakuCachePath]];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            NSString *path = [openPanel.URL.path stringByAppendingPathComponent:@"dandanplay"];
            self.pathTextField.placeholderString = path;
            [UserDefaultManager shareUserDefaultManager].danmakuCachePath = path;
        }
    }];
}

@end
