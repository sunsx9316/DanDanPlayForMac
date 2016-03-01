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
- (NSString *)titleForRow:(NSInteger)row{
    return self.outlineViewArray[row];
}
- (NSInteger)numberOfTitle{
    return self.outlineViewArray.count;
}

- (NSInteger)numOfRowWithStyle:(preferenceTableViewStyle)style{
    switch (style) {
        case preferenceTableViewStyleDanMu:
            return 6;
            break;
        case preferenceTableViewStylePlayer:
            return 1;
            break;
        case preferenceTableViewStyleFilter:
            return 1;
            break;
        case preferenceTableViewStyleKeyboard:
            return 1;
            break;
        case preferenceTableViewStyleScreenShot:
            return 1;
            break;
        case preferenceTableViewStyleCache:
            return 1;
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载
- (NSArray *)outlineViewArray {
	if(_outlineViewArray == nil) {
        _outlineViewArray = @[@"弹幕设置", @"播放器设置", @"弹幕过滤设置", @"快捷键设置", @"截图设置", @"缓存管理"];
	}
	return _outlineViewArray;
}

@end
