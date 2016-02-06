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
/**
 *  根据关键词刷新
 *
 *  @param keyWord           关键词
 *  @param completionHandler 回调
 */
- (void)refreshWithKeyWord:(NSString *)keyWord completion:(void(^)(NSError *error))completionHandler;
@end
