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
            self.noneButton.state = 1;
            self.strokeButton.state = 0;
            self.shadowButton.state = 0;
            self.glowButton.state = 0;
            break;
        case 101:
            self.noneButton.state = 0;
            self.strokeButton.state = 1;
            self.shadowButton.state = 0;
            self.glowButton.state = 0;
            break;
        case 102:
            self.noneButton.state = 0;
            self.strokeButton.state = 0;
            self.shadowButton.state = 1;
            self.glowButton.state = 0;
            break;
        case 103:
            self.noneButton.state = 0;
            self.strokeButton.state = 0;
            self.shadowButton.state = 0;
            self.glowButton.state = 1;
            break;
        default:
            break;
    }
}

- (IBAction)clickButton:(NSButton *)sender {
    [UserDefaultManager setDanMuFontSpecially:sender.tag];
}

@end
