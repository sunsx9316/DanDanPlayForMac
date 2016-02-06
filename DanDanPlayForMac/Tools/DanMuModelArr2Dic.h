//
//  DanMuModelArr2Dic.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//  把弹幕数组转成字典的工具类
//



@interface DanMuModelArr2Dic : NSObject
/**
 *  把对象转成时间字典
 *
 *  @param obj   对象 官方和a站对应数组 b站是NSData
 *  @param style 弹幕来源
 *
 *  @return 时间字典
 */
+ (NSDictionary *)dicWithObj:(id)obj source:(kDanMuSource)source;
@end