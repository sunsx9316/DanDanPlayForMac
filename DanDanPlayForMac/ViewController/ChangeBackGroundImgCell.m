//
//  ChangeBackGroundImgCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ChangeBackGroundImgCell.h"
@interface ChangeBackGroundImgCell()
@property (strong, nonatomic) NSImageView *imageView;
@property (strong, nonatomic) NSImageView *BGImgView;
@property (weak) IBOutlet NSTextField *messageTextField;

@end

@implementation ChangeBackGroundImgCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview: self.BGImgView];
    [self addSubview: self.imageView];
    
    [self.BGImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.messageTextField.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(200);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.BGImgView);
        make.height.equalTo(self.BGImgView).mas_offset(-11);
    }];
}

- (IBAction)clickChangeBackGroundButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories: NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection: NO];
    
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *imgURL = [openPanel URLs].firstObject;
            NSImage *img = [[NSImage alloc] initWithContentsOfURL: imgURL];
            if (img == nil) {
                [[NSAlert alertWithMessageText:@"然而这并不是图片" defaultButton:@"哦" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
            }else{
                self.imageView.image = img;
                [UserDefaultManager setHomeImgPath:imgURL.path];
            }
        }
    }];
}
- (IBAction)clickRecoveryButton:(NSButton *)sender {
    self.imageView.image = [NSImage imageNamed:@"home"];
    [UserDefaultManager setHomeImgPath: nil];
}


#pragma mark - 懒加载
- (NSImageView *)imageView {
	if(_imageView == nil) {
        _imageView = [[NSImageView alloc] init];
        _imageView.image = [UserDefaultManager homeImg];
	}
	return _imageView;
}

- (NSImageView *)BGImgView {
	if(_BGImgView == nil) {
		_BGImgView = [[NSImageView alloc] init];
        _BGImgView.image = [NSImage imageNamed:@"homeBG"];
	}
	return _BGImgView;
}

@end
