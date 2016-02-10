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
@class DanMuDataModel, LocalVideoModel, VLCMedia;
@interface PlayViewModel : BaseViewModel
/**
 *  保存弹幕模型
 */
@property (nonatomic, strong) NSDictionary <NSNumber *, NSArray *>*dic;
@property (assign, nonatomic) NSInteger currentIndex;
/**
 *  获取当前VLCMedia
 *
 *  @param complete 回调
 */
- (void)currentVLCMediaWithCompletionHandler:(void(^)(VLCMedia *responseObj))complete;
/**
 *  获取当前LocalVideoModel
 *
 *  @return LocalVideoModel
 */
- (LocalVideoModel *)currentLocalVideoModel;
/**
 *  当前视频名称
 *
 *  @return 视频名称
 */
- (NSString *)currentVideoName;
/**
 *  获取当前秒的弹幕
 *
 *  @param second 秒
 *
 *  @return 当前秒的弹幕
 */
- (NSArray <DanMuDataModel *>*)currentSecondDanMuArr:(NSInteger)second;
/**
 *  初始化
 *
 *  @param localVideoModel 本地视频模型
 *  @param dic             弹幕字典
 *
 *  @return self
 */
- (instancetype)initWithLocalVideoModels:(NSArray *)localVideoModels danMuDic:(NSDictionary *)dic;
@end
