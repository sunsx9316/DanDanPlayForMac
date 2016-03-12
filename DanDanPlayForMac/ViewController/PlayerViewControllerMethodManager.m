//
//  PlayerViewControllerMethodManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerViewControllerMethodManager.h"
#import "PlayerHUDControl.h"
#import "DanMuDataFormatter.h"
#import <VLCKit/VLCMediaPlayer.h>
#import "DanMuNetManager.h"
#import "DanMuModel.h"

@implementation PlayerViewControllerMethodManager
+ (void)snapShotWithPlayer:(VLCMediaPlayer *)player snapshotName:(NSString *)snapshotName{
    NSString *path = [UserDefaultManager screenShotPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path = [path stringByAppendingPathComponent:snapshotName];
    [player saveVideoSnapshotAt:path withWidth:0 andHeight:0];
    
    switch ([UserDefaultManager defaultScreenShotType]) {
        case 0:
            [self transformImgWithPath:path imgFileType:NSJPEGFileType suffixName:@".jpg"];
            break;
        case 1:
            [self transformImgWithPath:path imgFileType:NSPNGFileType suffixName:@".png"];
            break;
        case 2:
            [self transformImgWithPath:path imgFileType:NSBMPFileType suffixName:@".bmp"];
            break;
        case 3:
            [self transformImgWithPath:path imgFileType:NSTIFFFileType suffixName:@".tiff"];
            break;
        default:
            break;
    }
}

+ (CGFloat)videoTimeWithPlayer:(VLCMediaPlayer *)player{
    return player.media.length.numberValue.floatValue / 1000;
}
+ (CGFloat)currentTimeWithPlayer:(VLCMediaPlayer *)player{
    return player.time.numberValue.floatValue / 1000;
}
+ (void)showCursorAndHUDPanel:(PlayerHUDControl *)HUDPanel launchDanmakuView:(NSView *)launchDanmakuView{
    HUDPanel.animator.alphaValue = 1;
    launchDanmakuView.animator.alphaValue = 1;
}

+ (void)hideCursorAndHUDPanel:(PlayerHUDControl *)HUDPanel launchDanmakuView:(NSView *)launchDanmakuView{
    [NSCursor setHiddenUntilMouseMoves:YES];
    HUDPanel.animator.alphaValue = 0;
    launchDanmakuView.animator.alphaValue = 0;
}

+ (void)showDanMuControllerView:(NSScrollView *)scrollView withRect:(CGRect)scrollViewRect hideButton:(NSButton *)button{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        scrollView.animator.hidden = NO;
        scrollView.animator.frame = scrollViewRect;
        button.hidden = YES;
    } completionHandler:nil];
}

+ (void)hideDanMuControllerView:(NSScrollView *)scrollView withRect:(CGRect)scrollViewRect showButton:(NSButton *)button{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        scrollView.animator.hidden = YES;
        scrollView.animator.frame = scrollViewRect;
        button.hidden = NO;
    } completionHandler:nil];
}

+ (void)showPlayerListView:(NSScrollView *)playerListView withRect:(CGRect)playerListViewRect{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        playerListView.animator.frame = playerListViewRect;
        playerListView.animator.hidden = NO;
    } completionHandler:nil];
}

+ (void)hidePlayerListView:(NSScrollView *)playerListView withRect:(CGRect)playerListViewRect{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        playerListView.animator.frame = playerListViewRect;
        playerListView.animator.hidden = YES;
    } completionHandler:nil];
}

+ (void)loadLocaleDanMuWithBlock:(loadLocalDanMuBlock)block{
        NSOpenPanel* openPanel = [NSOpenPanel openPanel];
        [openPanel setTitle:@"选取弹幕"];
        [openPanel setCanChooseDirectories: NO];
        [openPanel setCanChooseFiles:YES];
        [openPanel setAllowsMultipleSelection: NO];
        [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:^(NSInteger result) {
            if (result == NSFileHandlingPanelOKButton){
                //acfun：json解析方式
                id obj = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:openPanel.URL] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
                NSDictionary *dic = nil;
                if (obj) {
                    dic = [DanMuDataFormatter dicWithObj:obj source:JHDanMuSourceAcfun];
                }else{
                //bilibili：xml解析方式
                    dic = [DanMuDataFormatter dicWithObj:[NSData dataWithContentsOfURL:openPanel.URL] source:JHDanMuSourceBilibili];
                }
                block(dic);
            }
        }];
}

+ (void)launchDanmakuWithText:(NSString *)text color:(NSInteger)color mode:(NSInteger)mode time:(NSTimeInterval)time episodeId:(NSString *)episodeId completionHandler:(void(^)(DanMuDataModel *model ,NSError *error))completionHandler{
    if (!episodeId) {
        completionHandler(nil, kObjNilError);
        return;
    }
    
    DanMuDataModel *model = [[DanMuDataModel alloc] init];
    model.color = color;
    model.time = time;
    model.mode = mode;
    model.message = text;
    [DanMuNetManager launchDanmakuWithModel:model episodeId:episodeId completionHandler:^(NSError *error) {
        completionHandler(model, error);
    }];
}

#pragma mark - 私有方法
+ (void)transformImgWithPath:(NSString *)path imgFileType:(NSBitmapImageFileType)imgFileType suffixName:(NSString *)suffixName{
    
    if (imgFileType == NSPNGFileType) {
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:[path stringByAppendingPathExtension:@"png"] error:nil];
    }else{
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
        if (!image) return;
        CGImageRef cgRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
        [newRep setSize:[image size]];
        NSData *pngData = [newRep representationUsingType:imgFileType properties: @{}];
        [pngData writeToFile:[NSString stringWithFormat:@"%@%@",path,suffixName] atomically:YES];
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
@end
