//
//  NSTableView+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSTableView+Tools.h"

@implementation NSTableView (Tools)
- (void)reloadRow:(NSUInteger)row inColumn:(NSUInteger)column {
    [self reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex: column]];
}
@end
