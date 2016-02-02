//
//  DanMuChooseViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuChooseViewModel.h"
#import "DanMuNetManager.h"
#import "VideoInfoModel.h"
#import "NSArray+Tools.h"
@interface DanMuChooseViewModel()
@property (nonatomic, strong) NSString *videoID;
@end

@implementation DanMuChooseViewModel
- (NSString *)supplierNameWithIndex:(NSInteger)index{
    return [self.supplierArr objectOrNilAtIndex: index];
}
- (NSString *)shiBanTitleWithIndex:(NSInteger)index{
    return [[self.shiBanArr objectOrNilAtIndex: index] title];
}
- (NSString *)episodeTitleWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] title];
}
- (NSString *)danMuKuWithIndex:(NSInteger)index{
    return [[self.episodeTitleArr objectOrNilAtIndex: index] danMuKu];
}

- (NSInteger)supplierNum{
    return self.supplierArr.count;
}
- (NSInteger)shiBanNum{
    return self.shiBanArr.count;
}
- (NSInteger)episodeNum{
    return self.episodeTitleArr.count;
}



- (void)refreshCompletionHandler:(void (^)(NSError *))complete{
    [DanMuNetManager getWithParameters:@{@"id": self.videoID} completionHandler:^(NSDictionary *responseObj, NSError *error){
        self.contentDic = responseObj;
        self.supplierArr = responseObj.allKeys;
        self.shiBanArr = responseObj[self.supplierArr.firstObject];
        self.episodeTitleArr = self.shiBanArr.firstObject.videos;
        complete(error);
    }];
}


- (instancetype)initWithVideoDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.contentDic = dic;
        self.supplierArr = dic.allKeys;
        self.shiBanArr = dic[self.supplierArr.firstObject];
        self.episodeTitleArr = self.shiBanArr.firstObject.videos;
    }
    return self;
}
@end
