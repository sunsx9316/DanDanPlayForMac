//
//  FontSpecially.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "FontSpeciallyCell.h"
@interface FontSpeciallyCell()
@property (weak) IBOutlet NSButton *noneButton;
@property (weak) IBOutlet NSButton *strokeButton;
@property (weak) IBOutlet NSButton *shadowButton;
@property (weak) IBOutlet NSButton *glowButton;


@end


@implementation FontSpeciallyCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSInteger value = [UserDefaultManager danMufontSpecially];
    
    switch (value) {
        case 100:
            self.noneButton.state = NSModalResponseOK;
            self.strokeButton.state = NSModalResponseCancel;
            self.shadowButton.state = NSModalResponseCancel;
            self.glowButton.state = NSModalResponseCancel;
            break;
        case 101:
            self.noneButton.state = NSModalResponseCancel;
            self.strokeButton.state = NSModalResponseOK;
            self.shadowButton.state = NSModalResponseCancel;
            self.glowButton.state = NSModalResponseCancel;
            break;
        case 102:
            self.noneButton.state = NSModalResponseCancel;
            self.strokeButton.state = NSModalResponseCancel;
            self.shadowButton.state = NSModalResponseOK;
            self.glowButton.state = NSModalResponseCancel;
            break;
        case 103:
            self.noneButton.state = NSModalResponseCancel;
            self.strokeButton.state = NSModalResponseCancel;
            self.shadowButton.state = NSModalResponseCancel;
            self.glowButton.state = NSModalResponseOK;
            break;
        default:
            break;
    }
}

- (IBAction)clickButton:(NSButton *)sender {
    [UserDefaultManager setDanMuFontSpecially:sender.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_FONT_SPECIALLY" object:nil userInfo:@{@"fontSpecially": @(sender.tag)}];
}

@end
