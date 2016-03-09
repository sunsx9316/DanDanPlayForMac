//
//  PlayerViewController.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface PlayerViewController : NSViewController
/**
 *  初始化
 *
 *  @param videoModel 视频模型
 *  @param arr             弹幕数组
 *  @param matchName       精确匹配文件名
 *  @param episodeId       分集id
 *  @return self
 */
- (instancetype)initWithVideos:(NSArray *)videoModels danMuDic:(NSDictionary *)dic matchName:(NSString *)matchName episodeId:(NSString *)episodeId;
@end
