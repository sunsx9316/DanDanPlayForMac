//
//  UseFilterExpressionCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "UseFilterExpressionCell.h"
@interface UseFilterExpressionCell()
@property (strong, nonatomic) clickBlock block;
@end

@implementation UseFilterExpressionCell
- (IBAction)clickButton:(NSButton *)sender {
    if (self.block) {
        self.block(sender.state);
    }
}

- (void)setWithBlock:(clickBlock)block{
    self.block = block;
}

@end
