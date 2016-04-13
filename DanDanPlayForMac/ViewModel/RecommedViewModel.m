//
//  RecommedViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommedViewModel.h"
#import "RecommedNetManager.h"
#import "FeaturedModel.h"
#import "BangumiModel.h"

@interface RecommedViewModel()
@property (strong, nonatomic) FeaturedModel *featured;
@property (strong, nonatomic) NSArray *bangumis;
@end

@implementation RecommedViewModel
- (NSURL *)headImgURL{
    return self.featured.imageURL;
}
- (NSString *)headTitle{
    return self.featured.title;
}
- (NSString *)headCategory{
    return self.featured.category;
}
- (NSString *)headIntroduction{
    return self.featured.introduction;
}
- (NSString *)headFileReviewURL{
    return self.featured.fileReviewURL;
}
- (NSInteger)numOfRow{
    return (self.featured != nil) + self.bangumis.count;
}

- (NSURL *)imgURLForRow:(NSInteger)row{
    return [self dataModelForRow:row].imageURL;
}
- (NSString *)titleForRow:(NSInteger)row{
    return [self dataModelForRow:row].name;
}
- (NSString *)keyWordForRow:(NSInteger)row{
    return [self dataModelForRow:row].keyWord;
}
- (NSArray *)groupsForRow:(NSInteger)row{

    return [self dataModelForRow:row].groups;
}


#pragma mark - 私有方法
- (BangumiDataModel *)dataModelForRow:(NSInteger)row{
    NSInteger offset = (self.featured != nil);
    return row - offset < self.bangumis.count ? self.bangumis[row - offset] : nil;
}

- (void)refreshWithCompletionHandler:(void(^)(NSError *error))completion{
    [RecommedNetManager recommedInfoWithCompletionHandler:^(id responseObj, NSError *error) {
        self.featured = responseObj[@"featured"];
        self.bangumis = [responseObj[@"bangumi"] bangumis];
        completion(error);
    }];
}
@end
