//
//  FeaturedModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
/**
 *  今日推荐模型
 */
@interface FeaturedModel : BaseModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *fileReviewPath;
@end
