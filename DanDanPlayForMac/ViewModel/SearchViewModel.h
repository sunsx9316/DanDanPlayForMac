//
//  SearchViewModel.h
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class SearchDataModel, VideoModel;

@interface SearchViewModel : BaseViewModel
@property (nonatomic, strong) NSArray<NSDictionary *> *models;
/**
 *  当前item数
 *
 *  @param item item
 *
 *  @return item数
 */
//- (NSInteger)numberOfChildrenOfItem:(id)item;
///**
// *  item是否可展开
// *
// *  @param item item
// *
// *  @return 是否可展开
// */
//- (BOOL)ItemExpandable:(id)item;
///**
// *  当前item的子item
// *
// *  @param index 下标
// *  @param item  当前item
// *
// *  @return 子item
// */
//- (id)child:(NSInteger)index ofItem:(id)item;
///**
// *  当前item内容
// *
// *  @param item 当前item
// *
// *  @return 内容
// */
//- (NSString *)itemContentWithItem:(id)item;

/**
 *  根据关键词刷新
 *
 *  @param keyWord  关键词
 *  @param complete 回调
 */
- (void)refreshWithKeyword:(NSString*)keyword completionHandler:(void(^)(NSError *error))complete;
@end
