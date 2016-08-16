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
 *  通过模型获取高度
 *
 *  @param model 模型
 *
 *  @return 高度
 */
- (CGFloat)heightWithModel:(FeaturedModel *)model;
@end
