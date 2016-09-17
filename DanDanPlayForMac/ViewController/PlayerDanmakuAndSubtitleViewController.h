//
//  PlayerDanmakuAndSubtitleViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
#import "PlayerDanmakuViewController.h"
#import "PlayerSubtitleViewController.h"
/**
 *  弹幕和字幕控制面板
 */
@interface PlayerDanmakuAndSubtitleViewController : BaseViewController
@property (strong, nonatomic) PlayerDanmakuViewController *danmakuVC;
@property (strong, nonatomic) PlayerSubtitleViewController *subtitleVC;

@end
