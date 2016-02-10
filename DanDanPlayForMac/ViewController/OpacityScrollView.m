//
//  OpacityScrollView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/7.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OpacityScrollView.h"

@implementation OpacityScrollView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)isOpaque{
    return YES;
}
@end
