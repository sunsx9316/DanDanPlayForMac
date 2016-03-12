//
//  RecommedViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class BangumiGroupModel;
@interface RecommedViewModel : BaseViewModel
- (NSURL *)headImgURL;
- (NSString *)headTitle;
- (NSString *)headCategory;
- (NSString *)headIntroduction;
- (NSString *)headFileReviewURL;
- (NSInteger)numOfRow;

//今天推荐的番剧
- (NSURL *)imgURLForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSString *)keyWordForRow:(NSInteger)row;
- (NSArray *)groupsForRow:(NSInteger)row;

- (void)refreshWithCompletionHandler:(void(^)(NSError *error))completion;
@end
