//
//  HomePageModel.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 16/10/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHHomePage.h"

@implementation JHBannerPage

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"Description",
             @"imageURL" : @"ImageUrl",
             @"name" : @"Title",
             @"link" : @"Url"};
}

@end

@implementation JHFeatured

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"Title",
             @"imageURL" : @"ImageUrl",
             @"category" : @"Category",
             @"desc" : @"Introduction",
             @"link" : @"Url"};
}

@end

@implementation JHBangumiCollection
{
    NSString *_weekDayStringValue;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"weekDay" : @"DayOfWeek",
             @"collection" : @"bangumis"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"collection" : [JHBangumi class]};
}

- (NSString *)weekDayStringValue {
    
    if (_weekDayStringValue) return _weekDayStringValue;
    
    switch (_weekDay) {
        case 0:
            _weekDayStringValue =  @"星期天";
            break;
        case 1:
            _weekDayStringValue = @"星期一";
            break;
        case 2:
            _weekDayStringValue = @"星期二";
            break;
        case 3:
            _weekDayStringValue = @"星期三";
            break;
        case 4:
            _weekDayStringValue = @"星期四";
            break;
        case 5:
            _weekDayStringValue = @"星期五";
            break;
        case 6:
            _weekDayStringValue = @"星期六";
            break;
    }
    
    if (!_weekDayStringValue) {
        _weekDayStringValue = @"";
    }
    
    return _weekDayStringValue;
}

@end

@implementation JHBangumi

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"imageURL":@"ImageUrl",
             @"keyword":@"Keyword",
             @"name":@"Name",
             @"collection":@"Groups",
             @"isFavorite": @"IsFavorite"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"collection" : [JHBangumiGroup class]};
}

@end

@implementation JHBangumiGroup

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name":@"GroupName",
             @"link":@"SearchUrl"};
}

@end

@implementation JHHomePage

@end
