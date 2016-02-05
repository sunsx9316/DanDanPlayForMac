//
//  PlayerViewController.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LocalVideoModel, VLCMedia;
@interface PlayerViewController : NSViewController
- (instancetype)initWithLocaleVideo:(LocalVideoModel *)localVideoModel vlcMedia:(VLCMedia *)media danMuDic:(NSDictionary *)dic;
@end
