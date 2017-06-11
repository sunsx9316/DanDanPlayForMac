//
//  JHBaseDanmaku+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 2017/6/10.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "JHBaseDanmaku+Tools.h"

@implementation JHBaseDanmaku (Tools)

- (BOOL)filter {
    NSNumber *number = objc_getAssociatedObject(self, "filter");
    return number.boolValue;
}

- (void)setFilter:(BOOL)filter {
    objc_setAssociatedObject(self, "filter", @(filter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
