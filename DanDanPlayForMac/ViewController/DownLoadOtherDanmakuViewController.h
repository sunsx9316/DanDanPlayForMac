//
//  DownLoadOtherDanmakuViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
@class VideoInfoDataModel;
@interface DownLoadOtherDanmakuViewController : BaseViewController
@property (strong, nonatomic) NSArray <VideoInfoDataModel *>*videos;
@property (assign, nonatomic) DanDanPlayDanmakuSource source;
@end
