//
//  ChangeBackGroundImgCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ChangeBackGroundImgCell.h"
#import "NSAlert+Tools.h"
#import "NSOpenPanel+Tools.h"

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
    NSOpenPanel* openPanel = [NSOpenPanel chooseFilePanelWithTitle:@"选择背景图" defaultURL:nil];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *imgURL = [openPanel URLs].firstObject;
            NSImage *img = [[NSImage alloc] initWithContentsOfURL:imgURL];
            if (img == nil) {
                [[NSAlert alertWithMessageText:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeFileIsNotImage].message informativeText:nil] runModal];
            }
            else {
                self.imageView.image = img;
                [[UserDefaultManager shareUserDefaultManager] setHomeImgPath:imgURL.path];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_HOME_IMG" object:img];
            }
        }
    }];
}

- (IBAction)clickRecoveryButton:(NSButton *)sender {
    [[UserDefaultManager shareUserDefaultManager] setHomeImgPath:nil];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[UserDefaultManager shareUserDefaultManager].homeImgPath];
    self.imageView.image = img;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_HOME_IMG" object:img];
}


#pragma mark - 懒加载
- (NSImageView *)imageView {
	if(_imageView == nil) {
        _imageView = [[NSImageView alloc] init];
        _imageView.image = [[NSImage alloc] initWithContentsOfFile:[UserDefaultManager shareUserDefaultManager].homeImgPath];
	}
	return _imageView;
}

- (NSImageView *)BGImgView {
	if(_BGImgView == nil) {
		_BGImgView = [[NSImageView alloc] init];
        _BGImgView.image = [NSImage imageNamed:@"home_BG"];
	}
	return _BGImgView;
}

@end
