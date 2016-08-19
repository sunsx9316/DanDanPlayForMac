//
//  RecommedViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommedViewModel.h"
#import "RecommedNetManager.h"

//@interface RecommedViewModel()
////@property (strong, nonatomic) FeaturedModel *featured;
//@property (strong, nonatomic) NSArray *bangumis;
//@end

@implementation RecommedViewModel
//- (NSURL *)headImgURL {
//    return self.featured.imageURL;
//}
//
//- (NSString *)headTitle {
//    NSString *title = self.featured.title;
//    return title.length ? title : @"";
//}
//
//- (NSString *)headCategory {
//    NSString *category = self.featured.category;
//    return category.length ? category : @"";
//}
//
//- (NSString *)headIntroduction {
//    NSString *introduction = self.featured.introduction;
//    return introduction.length ? introduction : @"";
//}
//
//- (NSString *)headFileReviewURL {
//    return self.featured.fileReviewURL;
//}
//
//- (NSInteger)numOfRow{
//    return (self.featured != nil) + self.bangumis.count;
//}

//- (NSURL *)imgURLForRow:(NSInteger)row {
//    return [self dataModelForRow:row].imageURL;
//}
//- (NSString *)titleForRow:(NSInteger)row {
//    NSString *name = [self dataModelForRow:row].name;
//    return name.length ? name : @"";
//}
//- (NSString *)keyWordForRow:(NSInteger)row {
//    return [self dataModelForRow:row].keyWord;
//}
//- (NSArray *)groupsForRow:(NSInteger)row {
//
//    return [self dataModelForRow:row].groups;
//}

- (BangumiModel *)bangumiModelWithIndex:(NSUInteger)index {
    return self.bangumis[index];
}

#pragma mark - 私有方法
//- (BangumiDataModel *)dataModelForRow:(NSInteger)row{
//    NSInteger offset = (self.featured != nil);
//    return row - offset < self.bangumis.count ? self.bangumis[row - offset] : nil;
//}

- (void)refreshWithCompletionHandler:(void(^)(DanDanPlayErrorModel *error))completion {
    [RecommedNetManager recommedInfoWithCompletionHandler:^(FeaturedModel *featuredModel, NSArray *bangumis, DanDanPlayErrorModel *error) {
        self.featuredModel = featuredModel;
        self.bangumis = bangumis;
        completion(error);
    }];
}
@end
