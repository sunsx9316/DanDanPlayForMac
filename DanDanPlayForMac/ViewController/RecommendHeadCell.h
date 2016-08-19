//
//  RecommendHeadCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FeaturedModel.h"

@interface RecommendHeadCell : NSView
/**
 *  设置模型
 *
 *  @param model 模型
 *
 */
- (void)setWithModel:(FeaturedModel *)model;
@property (copy, nonatomic) void(^clickSearchButtonCallBack)(NSString *keyWord);
@property (copy, nonatomic) void(^clickFilmReviewButtonCallBack)(NSString *fileReviewPath);
@end
