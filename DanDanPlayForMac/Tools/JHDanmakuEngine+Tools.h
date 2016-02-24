//
//  JHDanmakuEngine+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine.h"

@interface JHDanmakuEngine (Tools)
+ (ParentDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(danmakuShadowStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font;
@end
