//
//  MatchNetManager.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"
@class MatchModel;
@interface MatchNetManager : BaseNetManager
/**
 *  获取匹配结果
 *
 *  @param parameters 参数 
    1. fileName 视频文件名，不包含文件夹名称和扩展名，特殊字符需进行转义
    2. hash 文件前16MB(16x1024x1024Byte)数据的32位MD5结果
    3. length 文件总长度，单位为Byte。
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (id)getWithParameters:(NSDictionary*)parameters completionHandler:(void(^)(MatchModel* responseObj, NSError *error))complete;
@end
