//
//  Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef Tools_h
#define Tools_h

#define kViewControllerWithId(ID) [[NSStoryboard storyboardWithName:@"Main" bundle: nil] instantiateControllerWithIdentifier: ID]
//来源枚举
typedef NS_ENUM(NSInteger, JHDanMuSource){
    //官方
    JHDanMuSourceOfficial,
    //b站
    JHDanMuSourceBilibili,
    //a站
    JHDanMuSourceAcfun
};

#define RGBColor(r,g,b) RGBAColor(r,g,b,1)
#define RGBAColor(r,g,b,a) [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif /* Tools_h */
