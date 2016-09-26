//
//  PlayerMethodManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerMethodManager.h"
#import "DanmakuDataFormatter.h"
#import <VLCKit/VLCMediaPlayer.h>
#import "DanmakuNetManager.h"
#import "DanmakuModel.h"
#import "NSOpenPanel+Tools.h"

@implementation PlayerMethodManager

+ (void)controlView:(NSView *)controlView withRect:(CGRect)rect isHide:(BOOL)isHide completionHandler:(void(^)())completionHandler {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        controlView.animator.frame = rect;
        controlView.animator.hidden = isHide;
    } completionHandler:completionHandler];
}

+ (void)loadLocaleDanMuWithBlock:(loadLocalDanMuBlock)block {
    NSOpenPanel* openPanel = [NSOpenPanel chooseFilePanelWithTitle:@"选取弹幕" defaultURL:nil];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            //acfun：json解析方式
            [self convertDanmakuWithURL:openPanel.URL completionHandler:^(NSDictionary *danmakuDic, DanDanPlayErrorModel *error) {
                block(danmakuDic);
            }];
        }
    }];
}

+ (void)loadLocaleSubtitleWithBlock:(loadLocalSubtitleBlock)block {
    NSOpenPanel* openPanel = [NSOpenPanel chooseFilePanelWithTitle:@"选取字幕" defaultURL:nil];
//    openPanel.allowedFileTypes = @[@"ass", @"srt"];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            block(openPanel.URL.path);
        }
    }];
}

+ (void)launchDanmakuWithText:(NSString *)text color:(NSInteger)color mode:(NSInteger)mode time:(NSTimeInterval)time episodeId:(NSString *)episodeId completionHandler:(void(^)(DanmakuDataModel *model ,DanDanPlayErrorModel *error))completionHandler {
    if (!episodeId.length) {
        completionHandler(nil, [DanDanPlayErrorModel errorWithCode:DanDanPlayErrorTypeEpisodeNoExist]);
        return;
    }
    
    DanmakuDataModel *model = [[DanmakuDataModel alloc] init];
    model.color = color;
    model.time = time;
    model.mode = mode;
    model.message = text;
    [DanmakuNetManager launchDanmakuWithModel:model episodeId:episodeId completionHandler:^(DanDanPlayErrorModel *error) {
        completionHandler(model, error);
    }];
}

+ (void)remakeConstraintsPlayerMediaView:(NSView *)mediaView size:(CGSize)size {
    CGSize screenSize = [NSScreen mainScreen].frame.size;
    mediaView.layer.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    //宽高有一个为0 使用布满全屏的约束
    if (size.width <= 0 || size.height <= 0) {
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    //当把视频放大到屏幕大小时 如果视频高超过屏幕高 则使用这个约束
    else if (screenSize.width * (size.height / size.width) > screenSize.height) {
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.bottom.mas_equalTo(0);
            make.width.equalTo(mediaView.mas_height).multipliedBy(size.width / size.height);
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
        }];
    }
    //没超过 使用这个约束
    else {
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.height.equalTo(mediaView.mas_width).multipliedBy(size.height / size.width);
        }];
    }
}

+ (void)showPlayLastWatchVideoTimeView:(PlayerLastWatchVideoTimeView *)timeView time:(NSTimeInterval)time {
    NSUInteger intTime = time;
    if (time > 0) {
        timeView.videoTimeTextField.text = [NSString stringWithFormat:@"上次播放时间: %.2ld:%.2ld",intTime / 60, intTime % 60];
        timeView.time = time;
        [timeView show];
    }
}

+ (void)convertDanmakuWithURL:(NSURL *)URL completionHandler:(void(^)(NSDictionary *danmakuDic ,DanDanPlayErrorModel *error))completionHandler {
    //acfun：json解析方式
    id obj = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:URL] options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dic = nil;
    if (obj) {
        dic = [DanmakuDataFormatter dicWithObj:obj source:DanDanPlayDanmakuSourceAcfun];
    }
    else{
        //bilibili：xml解析方式
        dic = [DanmakuDataFormatter dicWithObj:[NSData dataWithContentsOfURL:URL] source:DanDanPlayDanmakuSourceBilibili];
    }
    if (dic.count) {
        completionHandler(dic, nil);
    }
    else {
        completionHandler(nil, [DanDanPlayErrorModel errorWithCode:DanDanPlayErrorTypeNilObject]);
    }
}

#pragma mark - 私有方法
+ (void)transformImgWithPath:(NSString *)path imgFileType:(NSBitmapImageFileType)imgFileType suffixName:(NSString *)suffixName {
    
    if (imgFileType == NSPNGFileType) {
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:[path stringByAppendingPathExtension:@"png"] error:nil];
    }
    else {
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
