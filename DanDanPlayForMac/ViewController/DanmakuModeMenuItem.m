//
//  DanmakuModeMenuItem.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/3.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanmakuModeMenuItem.h"

@implementation DanmakuModeMenuItem
{
    NSInteger _mode;
}
- (instancetype)initWithMode:(NSInteger)mode title:(NSString *)title{
    if (self = [super initWithTitle:title action:nil keyEquivalent:@""]) {
        _mode = mode;
    }
    return self;
}
- (NSInteger)mode{
    return _mode;
}
@end
