//
//  AddTrackingAreaButton.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddTrackingAreaButton : NSButton
@property (copy, nonatomic) void(^mouseEnteredCallBackBlock)();
@property (copy, nonatomic) void(^mouseExitedCallBackBlock)();
@end
