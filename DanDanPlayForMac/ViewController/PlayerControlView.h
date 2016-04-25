//
//  PlayerControlView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "PlayerSlideView.h"
typedef enum : NSUInteger {
    PlayerControlViewStatusActive,
    PlayerControlViewStatusInActive,
    PlayerControlViewStatusHalfActive,
} PlayerControlViewStatus;

@interface PlayerControlView : NSView
@property (weak) IBOutlet PlayerSlideView *slideView;
@property (assign, nonatomic) PlayerControlViewStatus status;
@property (assign, nonatomic) BOOL leftExpansion;
@property (assign, nonatomic) BOOL rightExpansion;
//状态回调
@property (copy, nonatomic) void(^statusCallBackBlock)(PlayerControlViewStatus);
////失活状态回调
//@property (copy, nonatomic) void(^inActiveCallBackBlock)();
////半激活状态回调
//@property (copy, nonatomic) void(^halfActiveCallBackBlock)();
//左边状态回调
@property (copy, nonatomic) void(^leftCallBackBlock)(BOOL);
//右边状态回调
@property (copy, nonatomic) void(^rightCallBackBlock)(BOOL);
@end
