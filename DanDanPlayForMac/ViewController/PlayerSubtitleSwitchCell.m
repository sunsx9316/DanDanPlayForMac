//
//  PlayerSubtitleSwitchCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSubtitleSwitchCell.h"
#import "JHSwichButton.h"
@interface PlayerSubtitleSwitchCell ()
@property (weak, nonatomic) IBOutlet JHSwichButton *switchButton;
@property (weak, nonatomic) IBOutlet NSPopUpButton *popButton;
//@property (strong, nonatomic) NSTextField *titleLabel;
@end

@implementation PlayerSubtitleSwitchCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.switchButton addTarget:self action:@selector(touchSwithButton:)];
    [self.popButton setTarget:self];
    [self.popButton setAction:@selector(touchPopButton:)];
}

- (void)setSubtitleTitles:(NSArray *)subtitleTitles {
    [self.popButton removeAllItems];
    [self.popButton addItemsWithTitles:subtitleTitles];
}

- (NSArray *)subtitleTitles {
    return self.popButton.itemArray;
}

//
//- (instancetype)initWithFrame:(NSRect)frameRect {
//    if (self = [super initWithFrame:frameRect]) {
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_offset(10);
//        }];
//        
//        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(10);
//            make.left.mas_offset(10);
//            make.size.mas_equalTo(CGSizeMake(40, 20));
//        }];
//    }
//    return self;
//}
//

#pragma mark - 私有方法
- (void)touchSwithButton:(JHSwichButton *)button {
    if (self.touchButtonCallBack) {
        self.touchButtonCallBack(button.status);
    }
}

- (void)touchPopButton:(NSPopUpButton *)button {
    NSInteger index = button.indexOfSelectedItem;
    if (self.touchButtonCallBack && index < self.subtitleIndexs.count) {
        self.touchButtonCallBack([self.subtitleIndexs[index] integerValue]);
    }
}

//
//#pragma mark - 懒加载
//- (JHSwichButton *)button {
//	if(_button == nil) {
//		_button = [[JHSwichButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
//        _button.status = YES;
//        [_button addTarget:self action:@selector(touchButton)];
//        [self addSubview:_button];
//	}
//	return _button;
//}
//
//- (NSTextField *)titleLabel {
//    if(_titleLabel == nil) {
//        _titleLabel = [[NSTextField alloc] init];
//        _titleLabel.stringValue = @"弹幕开关";
//        _titleLabel.editable = NO;
//        _titleLabel.bordered = NO;
//        _titleLabel.drawsBackground = NO;
//        [_titleLabel setTextColor: [NSColor whiteColor]];
//        [self addSubview:_titleLabel];
//    }
//    return _titleLabel;
//}
@end
