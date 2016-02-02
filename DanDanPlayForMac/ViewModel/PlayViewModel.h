//
//  PlayViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
/**
 *  播放视图模型
 */
@class DanMuModel, DanMuDataModel, LocalVideoModel;
@interface PlayViewModel : BaseViewModel
/**
 *  获取当前秒的弹幕
 *
 *  @param second 秒
 *
 *  @return 当前秒的弹幕
 */
- (NSArray <DanMuDataModel *>*)currentSecondDanMuArr:(NSInteger)second;
/**
 *  视频路径
 *
 *  @return 路径
 */
- (NSURL *)videoURL;
/**
 *  初始化
 *
 *  @param localVideoModel 本地视频模型
 *  @param dic             弹幕字典
 *
 *  @return self
 */
- (instancetype)initWithLocalVideoModel:(LocalVideoModel *)localVideoModel danMuDic:(NSDictionary *)dic;
@end
