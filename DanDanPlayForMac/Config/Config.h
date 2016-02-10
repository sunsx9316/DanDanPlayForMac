//
//  Config.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define kViewControllerWithId(ID) [[NSStoryboard storyboardWithName:@"Main" bundle: nil] instantiateControllerWithIdentifier: ID]

//  appkey
#define APPKEY @"85eb6835b0a1034e"

//  appsec
#define APPSEC @"2ad42749773c441109bdc0191257a664"

#define kNoMatchError [NSError errorWithDomain:@"nomatchdanmaku" code:200 userInfo: nil]
//来源枚举
typedef NS_ENUM(NSInteger, kDanMuSource){
    //官方
    official,
    //b站
    bilibili,
    //a站
    acfun
};

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__);
#else
#define NSLog(...)
#endif

#endif /* Config_h */
