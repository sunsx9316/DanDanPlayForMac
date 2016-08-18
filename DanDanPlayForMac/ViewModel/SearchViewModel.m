//
//  SearchViewModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchNetManager.h"
#import "SearchModel.h"
@interface SearchViewModel()
@property (nonatomic, strong) NSArray<NSDictionary *> *models;

@end

@implementation SearchViewModel
#pragma mark - 番剧
- (NSInteger)numberOfChildrenOfItem:(id)item{
    //item存在时
    if (item) {
        //item是数组
        if ([item isKindOfClass: [NSArray class]] || [item isKindOfClass: [NSDictionary class]]) {
            return [item count];
            //item不是数组
        }else if ([item isKindOfClass: [SearchDataModel class]]){
            return [item episodes].count;
        }
        return 0;
    }
    //item不存在 说明为根节点
    return  [self.models count];
}
- (BOOL)ItemExpandable:(id)item{
    if (item) {
        if ([item isKindOfClass: [NSArray class]] || [item isKindOfClass: [NSDictionary class]])
            return [item count];
        else if ([item isKindOfClass: [SearchDataModel class]])
            return [item episodes].count;
    }
    return NO;
}
- (id)child:(NSInteger)index ofItem:(id)item{
    if (item) {
        if ([item isKindOfClass: [NSDictionary class]])
            return [[[item allValues] firstObject] objectAtIndex: index];
        else if ([item isKindOfClass: [NSArray class]])
            return item[index];
        else if ([item isKindOfClass: [SearchDataModel class]])
            return [[item episodes] objectAtIndex: index];
    }
    return self.models[index];
}
- (NSString *)itemContentWithItem:(id)item{
    if ([item isKindOfClass: [NSDictionary class]]) {
        return [item allKeys].firstObject;
    }else if ([item isKindOfClass: [SearchDataModel class]] || [item isKindOfClass: [EpisodesModel class]])
        return [item title];
    return nil;
}

- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete{
    [SearchNetManager GETWithParameters:@{@"anime": keyWord} completionHandler:^(SearchModel *responseObj, NSError *error) {
        NSMutableArray *arr = [self classifyModel: responseObj.animes];
        if (!arr.count) {
            SearchDataModel *model = [[SearchDataModel alloc] init];
            model.title = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
            [arr addObject:model];
        }
        self.models = arr;
        complete(error);
    }];
}

#pragma mark - 私有方法


/**
 *  模型分类
 *
 *  @return 分类好的模型
 */
- (NSMutableArray *)classifyModel :(NSArray<SearchDataModel*> *)arr{
    //分类
    NSMutableDictionary <NSString *,NSMutableArray *> *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *tempMap = @{@"1":@"TV动画", @"2":@"TV动画特别放送", @"3":@"OVA", @"4":@"剧场版", @"5":@"音乐视频", @"6":@"网络放送", @"7":@"其他", @"10":@"三次元电影", @"20":@"三次元电视剧或国产动画", @"99":@"未知"};
    [arr enumerateObjectsUsingBlock:^(SearchDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //对应类型第一次创建
        if (!tempDic[tempMap[obj.type]]) tempDic[tempMap[obj.type]] = [NSMutableArray array];
        [tempDic[tempMap[obj.type]] addObject: obj];
    }];
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) [tempArr addObject: @{key:obj}];
    }];
    return tempArr;
}

@end
