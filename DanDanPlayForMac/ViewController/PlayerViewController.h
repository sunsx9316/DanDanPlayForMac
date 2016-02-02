//
//  PlayerViewController.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LocalVideoModel;
@interface PlayerViewController : NSViewController
- (instancetype)initWithLocaleVideo:(LocalVideoModel *)localVideoModel danMuDic:(NSDictionary *)dic;
@end
