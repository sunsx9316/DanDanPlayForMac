//
//  RecommendBangumiCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BangumiModel.h"

@interface RecommendBangumiCell : NSView
- (void)setWithModel:(BangumiDataModel *)model;
@property (copy, nonatomic) void(^clickGroupsButtonCallBack)(BangumiGroupModel *model);
@end
