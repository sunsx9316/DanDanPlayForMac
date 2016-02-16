//
//  ReSelectDanMuCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ReSelectDanMuCell.h"
@interface ReSelectDanMuCell()
@property (strong, nonatomic) reselectBlock block;
@property (strong, nonatomic) NSButton *selectButton;
@end

@implementation ReSelectDanMuCell
- (void)setWithBlock:(reselectBlock)block{
    self.block = block;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview: self.selectButton];
        
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(self).mas_offset(-20);
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)clickButton{
    if (self.block) {
        self.block();
    }
}

#pragma mark - 懒加载
- (NSButton *)selectButton {
	if(_selectButton == nil) {
		_selectButton = [[NSButton alloc] init];
        [_selectButton setBezelStyle: NSRoundedBezelStyle];
        [_selectButton setTarget: self];
        [_selectButton setAction: @selector(clickButton)];
        _selectButton.title = @"重新选择弹幕";
	}
	return _selectButton;
}

@end
