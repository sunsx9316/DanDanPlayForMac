//
//  NSTableView+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTableView (Tools)
/**
 *  刷新
 *
 *  @param row    行
 *  @param column 列
 */
- (void)reloadRow:(NSUInteger)row inColumn:(NSUInteger)column;
@end
