//
//  Config.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef Config_h
#define Config_h
//配置的宏

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//static NSString *official = @"official";
//static NSString *bilibili = @"bilibili";
//static NSString *acfun = @"acfun";

//来源枚举
//typedef NS_ENUM(NSInteger, JHDanMuSource){
//    //官方
//    JHDanMuSourceOfficial,
//    //b站
//    JHDanMuSourceBilibili,
//    //a站
//    JHDanMuSourceAcfun,
//    //发送缓存
//    JHDanMuSourceCache
//};

//只能亦或用户发送缓存和其它
typedef NS_ENUM(NSUInteger, DanDanPlayDanmakuSource){
    /**
     *  未知来源
     */
    DanDanPlayDanmakuSourceUnknow = 0,
    /**
     *  官方
     */
    DanDanPlayDanmakuSourceOfficial = 1 << 0,
    /**
     *  b站
     */
    DanDanPlayDanmakuSourceBilibili = 1 << 1,
    /**
     *  a站
     */
    DanDanPlayDanmakuSourceAcfun = 1 << 2,
    /**
     *  缓存
     */
    DanDanPlayDanmakuSourceCache = 1 << 3,
    /**
     *  用户发送缓存
     */
    DanDanPlayDanmakuSourceUserSendCache = 1 << 4
};

//项目主色调
#define MAIN_COLOR RGBColor(49, 169, 226)

//官方的key
#define kDanDanPlayKey @""
//官方的IV
#define kDanDanPlayIV @""

#endif /* Config_h */
