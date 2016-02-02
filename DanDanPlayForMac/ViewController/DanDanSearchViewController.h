//
//  DanDanSearchViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/31.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class VideoModel;
@interface DanDanSearchViewController : NSViewController
- (void)refreshWithKeyWord:(NSString *)keyWord completion:(void(^)(NSError *error))completionHandler;
@end
