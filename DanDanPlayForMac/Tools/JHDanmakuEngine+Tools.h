//
//  JHDanmakuEngine+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <JHDanmakuEngine.h>
@class DanmakuDataModel;
@interface JHDanmakuEngine (Tools)
+ (JHBaseDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(JHDanmakuEffectStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font;

+ (JHBaseDanmaku *)DanmakuWithModel:(DanmakuDataModel *)model shadowStyle:(JHDanmakuEffectStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font;
@end
