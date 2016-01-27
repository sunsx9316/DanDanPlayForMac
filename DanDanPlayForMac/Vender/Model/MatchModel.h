//
//  MatchModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
/**
 *  匹配模型
 */
@class MatchDataModel;
@interface MatchModel : BaseModel
@property (nonatomic, strong)NSArray<MatchDataModel*>* matches;
@end

@interface MatchDataModel : BaseModel
/**
 *  分集id
 */
@property (nonatomic, strong)NSString* episodeId;
/**
 *  标题
 */
@property (nonatomic, strong) NSString* animeTitle;
/**
 *  类型
 */
@property (nonatomic, strong) NSString* episodeTitle;
@end