//
//  FeaturedModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "FeaturedModel.h"

@implementation FeaturedModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"title":@"Title",@"imageURL":@"ImageUrl",@"category":@"Category",@"introduction":@"Introduction",@"fileReviewPath":@"Url"};
}
@end
