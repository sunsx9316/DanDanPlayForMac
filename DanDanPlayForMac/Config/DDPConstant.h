//
//  DDPConstant.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 2018/10/21.
//  Copyright © 2018 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DDPConstant_h
#define DDPConstant_h

//只能亦或用户发送缓存和其它

typedef NS_OPTIONS(NSUInteger, DanDanPlayDanmakuSource){
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


#endif /* DDPConstant_h */
