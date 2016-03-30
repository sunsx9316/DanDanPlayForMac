//
//  PlayerControlView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlayerSlideView.h"

@interface PlayerControlView : NSView
@property (weak) IBOutlet PlayerSlideView *slideView;
@property (copy, nonatomic) void(^mouseEnteredCallBackBlock)();
@property (copy, nonatomic) void(^mouseExitedCallBackBlock)();
@end
