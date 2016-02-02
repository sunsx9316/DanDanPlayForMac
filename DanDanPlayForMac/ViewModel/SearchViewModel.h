//
//  SearchViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class SearchDataModel, VideoModel;

@interface SearchViewModel : BaseViewModel

- (NSInteger)numberOfChildrenOfItem:(id)item;
- (BOOL)ItemExpandable:(id)item;
- (id)child:(NSInteger)index ofItem:(id)item;
- (NSString *)itemContentWithItem:(id)item;

/**
 *  根据关键词刷新
 *
 *  @param keyWord  关键词
 *  @param complete 回调
 */
- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete;
@end
