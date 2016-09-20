//
//  JHProgressHUD+Tools.m
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHProgressHUD+Tools.h"

@implementation JHProgressHUD (Tools)
- (void)showWithMessage:(NSString *)message style:(JHProgressHUDStyle)style parentView:(NSView *)parentView indicatorSize:(CGSize)indicatorSize fontSize:(float)fontSize hideWhenClick:(BOOL)hideWhenClick {
    self.text = message;
    self.style = style;
    self.indicatorSize = indicatorSize;
    self.textFont = [NSFont systemFontOfSize:fontSize];
    self.hideWhenClick = hideWhenClick;
    [self showWithView:parentView];
}

- (void)showWithMessage:(NSString *)message parentView:(NSView *)parentView {
    self.text = message;
    self.style = JHProgressHUDStyleValue1;
    self.indicatorSize = CGSizeMake(30, 30);
    self.textFont = [NSFont systemFontOfSize:[NSFont systemFontSize]];
    [self showWithView:parentView];

}
@end
