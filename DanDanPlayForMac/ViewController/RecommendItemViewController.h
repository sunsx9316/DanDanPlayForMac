//
//  RecommendItemViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
//弹弹原来的路径
#define OLD_PATH @"http://dmhy.dandanplay.com"
//新的路径
#define NEW_PATH @"https://share.dmhy.org"
//搜索路径
#define SEARCH_PATH @"https://share.dmhy.org/topics/list?keyword="

#import "JHHomePage.h"

@interface RecommendItemViewController : BaseViewController
@property (strong, nonatomic) JHBangumiCollection *model;
@end
