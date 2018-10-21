//
//  BangumiModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DDPBase.h"

@class BangumiDataModel, BangumiGroupModel;

@interface BangumiModel : DDPBase
@property (assign, nonatomic) NSInteger weekDay;
@property (strong, nonatomic, readonly) NSString *weekDayStringValue;
@property (strong, nonatomic) NSArray <BangumiDataModel *>*bangumis;
@end

@interface BangumiDataModel : DDPBase
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *keyWord;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSArray <BangumiGroupModel *>*groups;
@end

@interface BangumiGroupModel : DDPBase
@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSString *searchURL;
@end
