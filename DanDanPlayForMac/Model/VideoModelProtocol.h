//
//  VideoModelProtocol.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/17.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VideoModelProtocol <NSObject>
/**
 *  文件完整路径
 */
- (NSURL *)fileURL;
/**
 *  文件哈希值
 */
- (NSString *)md5;
/**
 *  文件名
 *
 */
- (NSString *)fileName;
/**
 *  匹配的名称
 */
@property (copy, nonatomic) NSString *matchTitle;
/**
 *  官方分集的id
 */
@property (copy, nonatomic) NSString *episodeId;

/**
 *  弹幕 不参与归档 所以写方法
 */
- (void)setDanmakuDic:(NSDictionary *)danmakuDic;
- (NSDictionary *)danmakuDic;
@end
