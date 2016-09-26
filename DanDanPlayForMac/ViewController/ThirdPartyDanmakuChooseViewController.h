//
//  BiliBiliDanmakuChooseViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
@interface ThirdPartyDanmakuChooseViewController : BaseViewController
/**
 *  初始化
 *
 *  @param videoID 视频aid
 *
 *  @return self
 */
+ (instancetype)viewControllerWithVideoId:(NSString *)videoId type:(DanDanPlayDanmakuSource)type;
@end
