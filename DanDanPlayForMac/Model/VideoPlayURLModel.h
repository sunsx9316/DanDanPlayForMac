//
//  VideoPlayURLModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
@class VideoPlayURLDataModel;
@interface VideoPlayURLModel : BaseModel
@property (strong, nonatomic) NSArray <VideoPlayURLDataModel *>*URLs;
@end

@interface VideoPlayURLDataModel : BaseModel
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSArray <NSString *>*backURLs;
@end