//
//  PreferenceViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, preferenceTableViewStyle) {
    preferenceTableViewStyleDamaku,
    preferenceTableViewStylePlayer,
    preferenceTableViewStyleFilter,
    preferenceTableViewStyleKeyboard,
    preferenceTableViewStyleScreenShot,
    preferenceTableViewStyleCache,
    preferenceTableViewStyleUpdate,
    preferenceTableViewStyleOther
};

#import "BaseViewModel.h"

@interface PreferenceViewModel : BaseViewModel
//outlineView
- (NSString *)titleForRow:(NSInteger)row;
- (NSInteger)numberOfTitle;

//tableView
- (NSInteger)numOfRowWithStyle:(preferenceTableViewStyle)style;

@end
