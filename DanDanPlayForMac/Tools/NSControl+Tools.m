//
//  NSControl+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSControl+Tools.h"

@implementation NSControl (Tools)
- (void)setText:(NSString *)text {
    if (!text.length) {
        text = @"";
    }
    self.stringValue = text;
}

- (NSString *)text {
    return self.stringValue;
}
@end
