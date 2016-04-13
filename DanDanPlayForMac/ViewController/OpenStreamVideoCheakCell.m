//
//  OpenStreamVideoCheakCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/10.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OpenStreamVideoCheakCell.h"
@interface OpenStreamVideoCheakCell()
@property (copy, nonatomic) clickCheakButtonCallBackBlock block;
@end

@implementation OpenStreamVideoCheakCell
- (void)setWithTitle:(NSString *)title callBackHandle:(clickCheakButtonCallBackBlock)callBackHandle {
    self.title = title;
    self.block = callBackHandle;
}

- (IBAction)clickButton:(NSButton *)sender {
    if (self.block) self.block(sender.state);
}

@end
