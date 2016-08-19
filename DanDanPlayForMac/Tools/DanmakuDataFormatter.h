//
//  DanmakuDataFormatter.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//  把弹幕数组转成字典的工具类
//


@class ParentDanmaku;
@interface DanmakuDataFormatter : NSObject
/**
 *  把对象转成时间字典
 *
 *  @param obj   对象 官方和a站对应数组 b站是NSData
 *  @param style 弹幕来源
 *
 *  @return 时间字典
 */
+ (NSMutableDictionary *)dicWithObj:(id)obj source:(DanDanPlayDanmakuSource)source;
/**
 *  把对象转成数组
 *
 *  @param obj    对象 官方和a站对应数组 b站是NSData
 *  @param source 弹幕来源
 *
 *  @return 数组
 */
+ (NSMutableArray *)arrWithObj:(id)obj source:(DanDanPlayDanmakuSource)source;
@end