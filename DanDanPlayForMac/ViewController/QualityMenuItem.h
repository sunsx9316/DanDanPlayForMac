//
//  QualityMenuItem.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/10.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StreamingVideoModel.h"

@interface QualityMenuItem : NSMenuItem
@property (assign, nonatomic) StreamingVideoQuality quality;
@end
