//
//  RecommendBangumiCell.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BangumiGroupModel;
@interface RecommendBangumiCell : NSView
- (void)setWithTitle:(NSString *)title keyWord:(NSString *)keyWord imgURL:(NSURL *)imgURL captionsGroup:(NSArray <BangumiGroupModel *>*)captionsGroup;
@end
