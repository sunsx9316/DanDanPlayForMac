//
//  UseFilterExpressionCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "UseFilterExpressionCell.h"

@implementation UseFilterExpressionCell
- (IBAction)clickButton:(NSButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.state);
    }
}

@end
