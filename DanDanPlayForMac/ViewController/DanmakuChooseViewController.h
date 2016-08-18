//
//  DanmakuChooseViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DanmakuChooseViewController : NSViewController
/**
 *  初始化
 *
 *  @param videoID dandanplay官方视频id
 *
 *  @return self
 */
- (instancetype)initWithVideoID:(NSString *)videoID;

@end
