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
@class DanMuModel, DanMuDataModel;
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
 *  初始化 传进来的model如果为DanMuModel直接播放 否则获取弹幕
 *
 *  @param model 模型
 *
 *  @return self
 */
- (instancetype)initWithModel:(id)model provider:(NSString *)provider;
/**
 *  获取弹幕
 *
 *  @param complete 回调
 */
- (void)getDanMuCompletionHandler:(void(^)(NSError *error))complete;
@end
