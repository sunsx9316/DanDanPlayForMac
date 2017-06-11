//
//  HomePageModel.h
//  DanDanPlayForiOS
//
//  Created by JimHuang on 16/10/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHBaseCollection.h"

@class JHBannerPage;
/**
 *  滚动页模型
 */
@interface JHBannerPage : JHBase

/**
 *  desc : 描述
    name : 名字
 */

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *link;
@end

/**
 *  今日推荐模型
 */
@interface JHFeatured : JHBase
/**
 *  name 标题
    link 跳转链接
    desc 介绍
 */

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *link;
@end


@class JHBangumiCollection, JHBangumi;
/**
 *  推荐番剧模型
 */
@interface JHBangumiCollection : JHBaseCollection
@property (assign, nonatomic) NSInteger weekDay;
@property (strong, nonatomic, readonly) NSString *weekDayStringValue;
//@property (strong, nonatomic) NSArray <JHBangumi *>*bangumis;
@end

@interface JHBangumi : JHBaseCollection
/**
 *  name 名称
 */
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSURL *imageURL;
@property (assign, nonatomic) BOOL isFavorite;
@end

@interface JHBangumiGroup : JHBase
/**
 *  name 名称
 */
@property (strong, nonatomic) NSString *link;
@end


/**
 *  主页模型
 */
@interface JHHomePage : JHBase
@property (strong, nonatomic) NSArray <JHBannerPage *>*bannerPages;
@property (strong, nonatomic) NSArray <JHBangumiCollection *>*bangumis;
@property (strong, nonatomic) JHFeatured *todayFeaturedModel;
@end
