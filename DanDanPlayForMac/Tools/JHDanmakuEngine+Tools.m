//
//  JHDanmakuEngine+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine+Tools.h"
#import "FloatDanmaku.h"
#import "ScrollDanmaku.h"
#import "NSColor+Tools.h"
#import "DanMuModel.h"

@implementation JHDanmakuEngine (Tools)
+ (ParentDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(danmakuShadowStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font{
    if (spiritStyle == 4 || spiritStyle == 5) {
        return [[FloatDanmaku alloc] initWithFontSize:fontSize textColor:[NSColor colorWithRGB:(uint32_t)color] text:text shadowStyle:shadowStyle font:font during:3 direction:spiritStyle == 4 ? floatDanmakuDirectionB2T : floatDanmakuDirectionT2B];
    }else{
        return [[ScrollDanmaku alloc] initWithFontSize:fontSize textColor:[NSColor colorWithRGB:(uint32_t)color] text:text shadowStyle:shadowStyle font:font speed:arc4random()%100 + 50 direction:scrollDanmakuDirectionR2L];
    }
}

+ (ParentDanmaku *)DanmakuWithModel:(DanMuDataModel *)model shadowStyle:(danmakuShadowStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font{
    return [self DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:shadowStyle fontSize:fontSize font:font];
}
@end
