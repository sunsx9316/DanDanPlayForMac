//
//  PlayerSubtitleFontSizeCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSubtitleFontSizeCell.h"
@interface PlayerSubtitleFontSizeCell()
@property (weak) IBOutlet NSTextField *textField;
@end

@implementation PlayerSubtitleFontSizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSFont *font = [UserDefaultManager subtitleAttDic][NSFontAttributeName];
    if (!font) {
        font = [NSFont systemFontOfSize:SUBTITLE_FONT_SIZE];
    }
    self.textField.stringValue = [NSString stringWithFormat:@"%.1f", font.pointSize / SUBTITLE_FONT_SIZE];
}

- (IBAction)sliderValueChange:(NSSlider *)sender {
    self.textField.stringValue = [NSString stringWithFormat:@"%.1f", sender.floatValue / SUBTITLE_FONT_SIZE];
    if (self.fontSizeChangeCallBack) {
        self.fontSizeChangeCallBack(sender.floatValue);
    }
}

@end
