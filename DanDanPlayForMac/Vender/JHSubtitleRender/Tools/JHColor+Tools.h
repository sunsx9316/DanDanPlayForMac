//
//  UIColor+Tools.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubtitleHeader.h"

@interface JHColor (Tools)
/**
 *  从字符串获取颜色
 *
 *  @param hexStr 字符串格式 bbggrr
 *
 *  @return 颜色
 */
+ (instancetype)colorWithHexString:(NSString *)hexStr;
@end
