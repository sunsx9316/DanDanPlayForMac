//
//  JHProgressHUD+Tools.h
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHProgressHUD.h"

@interface JHProgressHUD (Tools)
- (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView indicatorSize:(CGSize)indicatorSize fontSize:(float)fontSize hideWhenClick:(BOOL)hideWhenClick;
- (void)showWithMessage:(NSString *)message parentView:(NSView *)parentView;
@end
