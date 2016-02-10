//
//  BarrageDescriptor+Tools.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BarrageDescriptor.h"
#import "BarrageHeader.h"
@class DanMuDataModel;
/**
 *  边缘类型
 */
typedef NS_ENUM(NSUInteger, DanMaKuSpiritEdgeStyle) {
    /**
     *  投影
     */
    DanMaKuSpiritEdgeStyleShadow,
    /**
     *  外发光
     */
    DanMaKuSpiritEdgeStyleGlow,
    /**
     *  描边
     */
    DanMaKuSpiritEdgeStyleStroke,
    /**
     *  啥也没有
     */
    DanMaKuSpiritEdgeStyleNone
};

@interface BarrageDescriptor (Tools)
+ (instancetype)descriptorWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle edgeStyle:(DanMaKuSpiritEdgeStyle)edgeStyle fontSize:(CGFloat)fontSize;
@end
