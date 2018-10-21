//
//  NSData+DanDanPlayEncrypt.h
//  DanDanPlayForiOS
//
//  Created by JimHuang on 17/2/19.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DanDanPlayEncrypt)
/**
 *  按照弹弹的加密方式进行加密
 *
 *  @return 加密二进制
 */
- (NSData *)encryptWithDandanplayType;
@end
