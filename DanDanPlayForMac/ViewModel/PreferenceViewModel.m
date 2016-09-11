//
//  PreferenceViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PreferenceViewModel.h"
@interface PreferenceViewModel()
@property (strong, nonatomic) NSArray *outlineViewArray;
@end

@implementation PreferenceViewModel
- (NSString *)titleForRow:(NSInteger)row {
    return self.outlineViewArray[row];
}
- (NSInteger)numberOfTitle {
    return self.outlineViewArray.count;
}

- (NSInteger)numOfRowWithStyle:(preferenceTableViewStyle)style {
    switch (style) {
        case preferenceTableViewStyleDamaku:
            return 6;
        case preferenceTableViewStylePlayer:
        case preferenceTableViewStyleFilter:
        case preferenceTableViewStyleKeyboard:
        case preferenceTableViewStyleScreenShot:
        case preferenceTableViewStyleCache:
        case preferenceTableViewStyleUpdate:
            return 1;
        case preferenceTableViewStyleOther:
            return 5;
        default:
            break;
    }
}

#pragma mark - 懒加载
- (NSArray *)outlineViewArray {
	if(_outlineViewArray == nil) {
        _outlineViewArray = @[@"弹幕设置", @"播放器设置", @"弹幕过滤设置", @"快捷键设置", @"截图设置", @"缓存管理", @"更新设置",@"其它设置"];
	}
	return _outlineViewArray;
}

@end
