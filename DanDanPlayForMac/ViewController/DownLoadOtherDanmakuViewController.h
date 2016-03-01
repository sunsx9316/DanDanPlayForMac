//
//  DownLoadOtherDanmakuViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class VideoInfoDataModel;
@interface DownLoadOtherDanmakuViewController : NSViewController
- (instancetype)initWithVideos:(NSArray <VideoInfoDataModel *>*)videos danMuSource:(NSString *)danMuSource;
@end
