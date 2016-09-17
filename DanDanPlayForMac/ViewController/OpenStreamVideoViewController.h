//
//  OpenStreamVideoViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"

@interface OpenStreamVideoViewController : BaseViewController
+ (instancetype)viewControllerWithURL:(NSString *)URL danmakuSource:(DanDanPlayDanmakuSource)danmakuSource;
@end
