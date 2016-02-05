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

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__);
#else
#define NSLog(...)
#endif

#endif /* Config_h */
