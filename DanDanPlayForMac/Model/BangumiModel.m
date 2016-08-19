//
//  BangumiModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BangumiModel.h"

@implementation BangumiModel
{
    NSString *_weekDayStringValue;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"weekDay":@"DayOfWeek",@"bangumis":@"BangumiDetails"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"bangumis":[BangumiDataModel class]};
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

@implementation BangumiDataModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"imageURL":@"ImageUrl",@"keyWord":@"Keyword",@"name":@"Name",@"groups":@"Groups"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"groups":[BangumiGroupModel class]};
}
@end

@implementation BangumiGroupModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"groupName":@"GroupName",@"searchURL":@"SearchUrl"};
}
@end