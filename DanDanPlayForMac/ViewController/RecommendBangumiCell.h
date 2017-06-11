//
//  RecommendBangumiCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "BangumiModel.h"
#import "JHHomePage.h"

@interface RecommendBangumiCell : NSView
- (void)setWithModel:(JHBangumi *)model;
@property (copy, nonatomic) void(^clickGroupsButtonCallBack)(JHBangumiGroup *model);
@end
