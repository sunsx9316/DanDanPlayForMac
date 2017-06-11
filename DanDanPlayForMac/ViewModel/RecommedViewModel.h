//
//  RecommedViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "JHHomePage.h"
//#import "FeaturedModel.h"
//#import "BangumiModel.h"

@interface RecommedViewModel : BaseViewModel
@property (strong, nonatomic) JHHomePage *model;
//@property (strong, nonatomic) FeaturedModel *featuredModel;
//@property (strong, nonatomic) NSArray <BangumiModel *>*bangumis;
//- (BangumiModel *)bangumiModelWithIndex:(NSUInteger)index;
//- (NSURL *)headImgURL;
//- (NSString *)headTitle;
//- (NSString *)headCategory;
//- (NSString *)headIntroduction;
//- (NSString *)headFileReviewURL;
////- (NSInteger)numOfRow;
//
////今天推荐的番剧
//- (NSURL *)imgURLForRow:(NSInteger)row;
//- (NSString *)titleForRow:(NSInteger)row;
//- (NSString *)keyWordForRow:(NSInteger)row;
//- (NSArray *)groupsForRow:(NSInteger)row;

- (void)refreshWithCompletionHandler:(void(^)(DanDanPlayErrorModel *error))completion;
@end
