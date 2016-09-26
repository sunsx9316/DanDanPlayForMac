//
//  MatchVideoInfoView.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImageView+Tools.h"

//左边显示番剧详情控制器
@interface ThirdPartySearchVideoInfoView : NSView
@property (strong, nonatomic) NSImageView *coverImg;
@property (strong, nonatomic) NSTextField *animaTitleTextField;
@property (strong, nonatomic) NSTextField *detailTextField;

@end
