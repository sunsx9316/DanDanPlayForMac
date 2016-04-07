//
//  ChangeFontCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ChangeFontCell.h"
@interface ChangeFontCell()
@property (weak) IBOutlet NSTextField *showTextField;
@property (strong, nonatomic) NSFont *font;
@property (strong, nonatomic) NSFontManager *manager;
@end

@implementation ChangeFontCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.showTextField.font = [self.manager convertFont:self.font toSize:self.showTextField.font.pointSize];
    self.showTextField.stringValue = [NSString stringWithFormat: @"%@: %.1f", self.font.familyName, self.font.pointSize];
}

- (IBAction)clickButton:(NSButton *)sender {
    [self.manager orderFrontFontPanel:self];
}

- (IBAction)clickResetFontButton:(NSButton *)sender {
    [UserDefaultManager setDanMuFont: nil];
    self.font = nil;
    [self changeFont:self.manager];
}


- (void)changeFont:(id)sender
{
    self.font = [sender convertFont: self.font];
    self.showTextField.stringValue = [NSString stringWithFormat: @"%@: %.1f", self.font.familyName, self.font.pointSize];
    self.showTextField.font = [sender convertFont: self.font toSize:self.showTextField.font.pointSize];
    [UserDefaultManager setDanMuFont: self.font];
    if (!_font) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_DANMAKU_FONT" object:nil userInfo:@{@"font":_font}];
}


- (NSFont *)font {
	if(_font == nil) {
        _font = [UserDefaultManager danMuFont];
	}
	return _font;
}

- (NSFontManager *)manager {
	if(_manager == nil) {
        _manager = [NSFontManager sharedFontManager];
        [_manager setTarget:self];;
	}
	return _manager;
}

@end
