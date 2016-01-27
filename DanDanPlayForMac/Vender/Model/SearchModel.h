//
//  AnimesModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
@class EpisodesModel, SearchDataModel;

/**
 *  搜索模型
 */
@interface SearchModel : BaseModel
@property (nonatomic, strong)NSArray<SearchDataModel*>* animes;
@end

@interface SearchDataModel : BaseModel
/**
 *  动画标题
 */
@property (nonatomic, strong)NSString* title;
/**
 *  动画类型
 1 - TV动画
 2 - TV动画特别放送
 3 - OVA
 4 - 剧场版
 5 - 音乐视频（MV）
 6 - 网络放送
 7 - 其他分类
 10 - 三次元电影
 20 - 三次元电视剧或国产动画
 99 - 未知（尚未分类）
 */
@property (nonatomic, strong)NSString* type;
/**
 *  分集
 */
@property (nonatomic, strong)NSArray<EpisodesModel*>* episodes;
@end

@interface EpisodesModel : BaseModel
/**
 *  分集标题
 */
@property (nonatomic, strong)NSString* title;
/**
 *  分集标识
 */
@property (nonatomic, strong)NSString* identity;
@end
