//
//  MatchViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
@class LocalVideoModel, MatchDataModel;
@interface MatchViewModel : BaseModel
@property (nonatomic, strong) NSArray<MatchDataModel*>* models;
/**
 *  匹配结果模型
 */
@property (nonatomic, strong) LocalVideoModel* videoModel;
/**
 *  根据模型刷新
 *
 *  @param complete 回调
 */
- (void)refreshWithCompletionHandler:(void(^)(DanDanPlayErrorModel *error, MatchDataModel *dataModel))complete;
@end
