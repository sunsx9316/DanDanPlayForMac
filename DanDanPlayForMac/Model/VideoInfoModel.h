//
//  VideoInfoModel.h
//  DanDanPlayer
//
//  Created by JimHuang on 16/1/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DDPBase.h"
@class VideoInfoDataModel;
/**
 *  视频详情模型
 */
@interface VideoInfoModel : DDPBase
/**
 *  番剧名称
 */
@property (nonatomic, strong) NSString *title;
/**
 *  番剧所有分集
 */
@property (nonatomic, strong) NSArray <VideoInfoDataModel *>*videos;
@end


@interface VideoInfoDataModel : DDPBase
@property (copy, nonatomic) NSString *aid;
/**
 *  弹幕id
 */
@property (nonatomic, strong) NSString *danmaku;
/**
 *  视频标题
 */
@property (nonatomic, strong) NSString *title;
@end

/**
 *  b站视频模型
 */
@interface BiliBiliVideoInfoModel : VideoInfoModel

@end

@interface BiliBiliVideoInfoDataModel : VideoInfoDataModel
@end

/**
 *  a站视频模型
 */
@interface AcfunVideoInfoModel : VideoInfoModel

@end

@interface AcfunVideoInfoDataModel : VideoInfoDataModel

@end
