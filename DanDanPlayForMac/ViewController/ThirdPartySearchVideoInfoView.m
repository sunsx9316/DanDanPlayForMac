//
//  MatchVideoInfoView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartySearchVideoInfoView.h"
@interface ThirdPartySearchVideoInfoView()
@property (strong, nonatomic) NSTextField *title;
@end

@implementation ThirdPartySearchVideoInfoView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview: self.title];
    [self addSubview: self.animaTitleTextField];
    [self addSubview: self.coverImg];
    [self addSubview: self.detailTextField];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_offset(5);
    }];
    
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).mas_offset(5);
        make.width.mas_lessThanOrEqualTo(150);
        make.centerX.mas_offset(0);
        make.height.equalTo(self.coverImg.mas_width).multipliedBy(1.325);
    }];
    
    [self.animaTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coverImg);
        make.top.greaterThanOrEqualTo(self.coverImg.mas_bottom).mas_offset(5);
    }];

    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.coverImg).mas_offset(60);
        make.centerX.equalTo(self.coverImg);
        make.top.equalTo(self.animaTitleTextField.mas_bottom).mas_offset(5);
    }];
}

#pragma mark - 懒加载
- (NSImageView *)coverImg {
    if(_coverImg == nil) {
        _coverImg = [[NSImageView alloc] init];
    }
    return _coverImg;
}

- (NSTextField *)animaTitleTextField {
    if(_animaTitleTextField == nil) {
        _animaTitleTextField = [[NSTextField alloc] init];
        _animaTitleTextField.editable = NO;
        _animaTitleTextField.bordered = NO;
        _animaTitleTextField.alignment = NSTextAlignmentCenter;
        _animaTitleTextField.drawsBackground = NO;
        _animaTitleTextField.font = [NSFont boldSystemFontOfSize: 16];
    }
    return _animaTitleTextField;
}

- (NSTextField *)detailTextField {
    if(_detailTextField == nil) {
        _detailTextField = [[NSTextField alloc] init];
        _detailTextField.editable = NO;
        _detailTextField.bordered = NO;
        _detailTextField.drawsBackground = NO;
        _detailTextField.preferredMaxLayoutWidth = 100;
    }
    return _detailTextField;
}
- (NSTextField *)title {
	if(_title == nil) {
		_title = [[NSTextField alloc] init];
        _title.stringValue = @"视频详情";
        _title.editable = NO;
        _title.bordered = NO;
        _title.drawsBackground = NO;
	}
	return _title;
}

@end
