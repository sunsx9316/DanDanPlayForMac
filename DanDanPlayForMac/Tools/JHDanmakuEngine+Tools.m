//
//  JHDanmakuEngine+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine+Tools.h"
#import "JHFloatDanmaku.h"
#import "JHScrollDanmaku.h"
#import "NSColor+Tools.h"
#import "DanmakuModel.h"

@implementation JHDanmakuEngine (Tools)
+ (JHBaseDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(JHDanmakuEffectStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font {
    if (spiritStyle == 4 || spiritStyle == 5) {
        return [[JHFloatDanmaku alloc] initWithFont:[NSFont systemFontOfSize:fontSize] text:text textColor:[NSColor colorWithRGB:(uint32_t)color] effectStyle:shadowStyle during:3 position:spiritStyle == 4 ? JHFloatDanmakuPositionAtBottom : JHFloatDanmakuPositionAtTop];
//        return [[JHFloatDanmaku alloc] initWithFontSize:fontSize textColor:[NSColor colorWithRGB:(uint32_t)color] text:text shadowStyle:shadowStyle font:font during:3 direction:spiritStyle == 4 ? JHFloatDanmakuDirectionB2T : JHFloatDanmakuDirectionT2B];
    }
    else {
        return [[JHScrollDanmaku alloc] initWithFont:[NSFont systemFontOfSize:fontSize] text:text textColor:[NSColor colorWithRGB:(uint32_t)color] effectStyle:shadowStyle speed:arc4random_uniform(100) + 50 direction:JHScrollDanmakuDirectionR2L];
//        return [[JHScrollDanmaku alloc] initWithFontSize:fontSize textColor:[NSColor colorWithRGB:(uint32_t)color] text:text shadowStyle:shadowStyle font:font speed:arc4random()%100 + 50 direction:JHScrollDanmakuDirectionR2L];
    }
}

+ (JHBaseDanmaku *)DanmakuWithModel:(DanmakuDataModel *)model shadowStyle:(JHDanmakuEffectStyle)shadowStyle fontSize:(CGFloat)fontSize font:(NSFont *)font {
    return [self DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:shadowStyle fontSize:fontSize font:font];
}
@end
