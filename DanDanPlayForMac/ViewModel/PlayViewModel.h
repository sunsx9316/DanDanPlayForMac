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
@property (strong, nonatomic) NSMutableArray *testarr;
/**
 *  保存弹幕模型
 */
@property (nonatomic, strong) NSDictionary <NSNumber *, NSArray *>*dic;
@property (assign, nonatomic) NSInteger currentIndex;
/**
 *  根据下标获取本地视频名称
 *
 *  @param index 下标
 *
 *  @return 名称
 */
- (NSString *)localeVideoNameWithIndex:(NSInteger)index;
/**
 *  获取视频总数
 *
 *  @return 总数
 */
- (NSInteger)localeVideoCount;
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
 *  获取当前VLCMedia
 *
 *  @param complete 回调
 */
- (void)currentVLCMediaWithCompletionHandler:(void(^)(VLCMedia *responseObj))complete;
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
