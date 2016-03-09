//
//  Config.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef Config_h
#define Config_h

//来源枚举
typedef NS_ENUM(NSInteger, JHDanMuSource){
    //官方
    JHDanMuSourceOfficial,
    //b站
    JHDanMuSourceBilibili,
    //a站
    JHDanMuSourceAcfun
};

#define kViewControllerWithId(ID) [[NSStoryboard storyboardWithName:@"Main" bundle: nil] instantiateControllerWithIdentifier: ID]
//错误
#define kNoMatchError [NSError errorWithDomain:@"nomatchdanmaku" code:200 userInfo: nil]
#define kObjNilError [NSError errorWithDomain:@"objnil" code:201 userInfo: nil]
//提示文本
#define kLoadMessage @"你不能让我加载 我就加载"

#define kNoFoundDanmaku @"・_ゝ・并没有找到弹幕"

//官方的key
#define kDanDanPlayKey @"hWfrNe2edWO6orxZYXHnJzwkIYIvoy3vtCrHu7OCz8k="
//官方的IV
#define kDanDanPlayIV @"dzweYfq6KUb3/BWny4IHxA=="

#endif /* Config_h */
