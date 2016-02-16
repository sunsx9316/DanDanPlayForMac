//
//  GetKeyViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
/**
 *  回调block
 *
 *  @param keyName 按键名
 *  @param keyCode 普通按键键值
 *  @param flag    特殊按键键值
 */
typedef void(^getKeyInfoBlock)(NSString *keyName, NSUInteger keyCode, NSUInteger flag);

@interface GetKeyViewController : NSViewController
- (instancetype)initWithFunctionName:(NSString *)functionName keyName:(NSString *)keyName getBlock:(getKeyInfoBlock)getBlock;
@end
