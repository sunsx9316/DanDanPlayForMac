//
//  PlayerMethodManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerMethodManager.h"
#import "DanMuDataFormatter.h"
#import <VLCKit/VLCMediaPlayer.h>
#import "DanMuNetManager.h"
#import "DanMuModel.h"

@implementation PlayerMethodManager

+ (void)controlView:(NSView *)controlView withRect:(CGRect)rect isHide:(BOOL)isHide completionHandler:(void(^)())completionHandler {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        controlView.animator.frame = rect;
        controlView.animator.hidden = isHide;
    } completionHandler:completionHandler];
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

+ (void)postMatchMessageWithMatchName:(NSString *)matchName delegate:(id)delegate{
    //删除已经显示过的通知(已经存在用户的通知列表中的)
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    
    //删除已经在执行的通知(比如那些循环递交的通知)
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]){
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"弹弹play";
    notification.informativeText = matchName?[NSString stringWithFormat:@"视频自动匹配为 %@", matchName]:@"并没有匹配到视频";
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = delegate;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

+ (void)remakeConstraintsPlayerMediaView:(NSView *)mediaView size:(CGSize)size{
    CGSize screenSize = [NSScreen mainScreen].frame.size;
    //宽高有一个为0 使用布满全屏的约束
    if (!size.width || !size.height) {
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //当把视频放大到屏幕大小时 如果视频高超过屏幕高 则使用这个约束
    }else if (screenSize.width * (size.height / size.width) > screenSize.height) {
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.bottom.mas_equalTo(0);
            make.width.equalTo(mediaView.mas_height).multipliedBy(size.width / size.height);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
        }];
        //没超过 使用这个约束
    }else{
        [mediaView  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.height.equalTo(mediaView.mas_width).multipliedBy(size.height / size.width);
        }];
    }
}

+ (void)showPlayLastWatchVideoTimeView:(PlayLastWatchVideoTimeView *)timeView time:(NSTimeInterval)time{
    NSUInteger intTime = time;
    if (time > 0) {
        timeView.videoTimeTextField.stringValue = [NSString stringWithFormat:@"上次播放时间: %.2ld:%.2ld",intTime / 60, intTime % 60];
        timeView.time = time;
        [timeView show];
    }
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
