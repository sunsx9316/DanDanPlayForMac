//
//  PlayerViewController.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalVideoModel.h"
#import "StreamingVideoModel.h"
#define AUTO_HIDE_TIME 5.0
@class PlayViewModel;
@interface PlayerViewController : BaseViewController
- (void)addVideos:(NSArray<id<VideoModelProtocol>>*)videos;
@property (strong, nonatomic) PlayViewModel *vm;
@end
