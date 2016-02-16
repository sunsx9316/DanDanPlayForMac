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
@end

@implementation ChangeFontCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.showTextField.stringValue = [NSString stringWithFormat: @"%@: %.1f", self.font.familyName, self.font.pointSize];
}

- (IBAction)clickButton:(NSButton *)sender {
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setTarget:self];
    [fontManager orderFrontFontPanel:self];
}

- (void)changeFont:(id)sender
{
    self.font = [sender convertFont: self.font];
    self.showTextField.stringValue = [NSString stringWithFormat: @"%@: %.1f", self.font.familyName, self.font.pointSize];
    [UserDefaultManager setDanMuFont: self.font];
}


- (NSFont *)font {
	if(_font == nil) {
        _font = [UserDefaultManager danMuFont];
	}
	return _font;
}

@end
