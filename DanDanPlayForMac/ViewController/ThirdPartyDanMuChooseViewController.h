//
//  BiliBiliDanMuChooseViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface ThirdPartyDanMuChooseViewController : NSViewController
/**
 *  初始化
 *
 *  @param videoID 视频aid
 *
 *  @return self
 */
- (instancetype)initWithVideoID:(NSString *)videoID type:(kDanMuSource)type;
@end
