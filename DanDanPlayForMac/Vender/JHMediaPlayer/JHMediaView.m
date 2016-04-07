//
//  JHMediaView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHMediaView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JHMediaView
- (BOOL)acceptsFirstResponder{
    return YES;
}

//- (void)resizeWithOldSuperviewSize:(NSSize)oldSize{
//    [CATransaction setDisableActions:YES];
//    [super resizeWithOldSuperviewSize:oldSize];
//    self.layer.bounds = CGRectMake(0, 0, oldSize.width, oldSize.height);
//}
@end
