//
//  RecommendHeadCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RecommendHeadCell : NSView
/**
 *  设置属性
 *
 *  @param title         标题
 *  @param info          视频信息
 *  @param brief         简介
 *  @param imgURL        视频封面
 *  @param filmReviewURL 影评路径
 */
- (void)setWithTitle:(NSString *)title info:(NSString *)info brief:(NSString *)brief imgURL:(NSURL *)imgURL FilmReviewURL:(NSString *)filmReviewURL;
/**
 *  cell高计算获取
 *
 *  @return cell高
 */
- (CGFloat)cellHeight;
@end
