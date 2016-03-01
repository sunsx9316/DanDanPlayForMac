//
//  PlayerViewController.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LocalVideoModel, VLCMedia;
@interface PlayerViewController : NSViewController
/**
 *  初始化
 *
 *  @param localVideoModel 本地视频模型
 *  @param media           vlc视频模型
 *  @param arr             弹幕数组
 *  @param matchName       精确匹配文件名
 *
 *  @return self
 */
- (instancetype)initWithLocaleVideos:(NSArray *)localVideoModels danMuDic:(NSDictionary *)dic matchName:(NSString *)matchName;
@end
