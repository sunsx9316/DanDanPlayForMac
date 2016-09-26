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

//弹弹官方的key
#define DANDANPLAY_KEY @"hWfrNe2edWO6orxZYXHnJzwkIYIvoy3vtCrHu7OCz8k="
//弹弹官方的IV
#define DANDANPLAY_IV @"dzweYfq6KUb3/BWny4IHxA=="

//b站的 appkey
#define BILIBILI_APPKEY @""
//b 站的 secretkey
#define BILIBILI_SECRETKEY @""

#endif /* Config_h */
