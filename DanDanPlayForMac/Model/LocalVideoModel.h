//
//  VideoModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
#import "VideoModel.h"
/**
 *  本地视频模型
 */
@interface LocalVideoModel : VideoModel
/**
 *  文件大小
 */
- (NSString *)length;
@end
