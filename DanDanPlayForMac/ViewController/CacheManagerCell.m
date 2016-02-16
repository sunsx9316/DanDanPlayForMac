//
//  CacheManagerCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "CacheManagerCell.h"

@implementation CacheManagerCell
- (IBAction)clickClearCacheButton:(NSButton *)sender {
    [UserDefaultManager setClearCache: sender.state];
}


@end
