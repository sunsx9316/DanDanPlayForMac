//
//  BiliBiliSearchViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class BiliBiliShiBanModel;
@interface BiliBiliSearchViewModel : BaseViewModel

- (NSInteger)shiBanArrCount;

- (NSInteger)infoArrCount;

- (NSString *)shiBanTitleForRow:(NSInteger)row;

- (NSString *)episodeTitleForRow:(NSInteger)row;

- (NSString *)seasonIDForRow:(NSInteger)row;

- (NSURL *)coverImg;

- (NSString *)shiBanTitle;

- (NSString *)shiBanDetail;

- (BOOL)isShiBanForRow:(NSInteger)row;

- (NSString *)aidForRow:(NSInteger)row;
/**
 *  根据关键词刷新 左视图
 *
 *  @param keyWord  关键词
 *  @param complete 回调
 */
- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete;
/**
 *  根据SeasonID刷新 右视图
 *
 *  @param SeasonID SeasonID
 *  @param complete 回调
 */
- (void)refreshWithSeasonID:(NSString*)SeasonID completionHandler:(void(^)(NSError *error))complete;

- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(NSError *error))complete;
@end
