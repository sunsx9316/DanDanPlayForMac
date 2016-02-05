//
//  MatchViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LocalVideoModel;
@interface MatchViewController : NSViewController
- (instancetype)initWithVideoModel:(LocalVideoModel *)videoModel;
@end
