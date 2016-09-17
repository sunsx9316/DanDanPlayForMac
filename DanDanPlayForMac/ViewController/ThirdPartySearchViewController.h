//
//  ThirdPartySearchViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
@interface ThirdPartySearchViewController : BaseViewController
/**
 *  番剧的 tableView
 */
@property (weak) IBOutlet NSTableView *shiBantableView;
/**
 *  分集的 tableView
 */
@property (weak) IBOutlet NSTableView *episodeTableView;
/**
 *  关键词
 */
@property (copy, nonatomic) NSString *keyword;
/**
 *  根据类型初始化
 *
 *  @param type 控制器类型
 *
 *  @return self
 */
+ (instancetype)viewControllerWithType:(DanDanPlayDanmakuSource)type;
@end
