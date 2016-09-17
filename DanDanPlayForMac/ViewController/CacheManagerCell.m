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

@interface CacheManagerCell()
@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSTextField *cacheTextField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

@implementation CacheManagerCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.pathTextField.placeholderString = [UserDefaultManager shareUserDefaultManager].danmakuCachePath;
    [self.progressIndicator startAnimation:self];
    self.progressIndicator.displayedWhenStopped = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        float size = [self folderSizeAtPath:[UserDefaultManager shareUserDefaultManager].danmakuCachePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cacheTextField.text = [NSString stringWithFormat:@"缓存大小: %.1fM", size];
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
        self.cacheTextField.text = @"缓存大小: 0.0M";
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

#pragma mark - 私有方法
- (NSInteger)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
