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
@property (weak, nonatomic) IBOutlet NSPopUpButton *popButton;
@end

@implementation PlayerSubtitleSwitchCell
- (void)awakeFromNib {
    [super awakeFromNib];
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

- (void)setCurrentSubTitleIndex:(int)currentSubTitleIndex {
    for (NSInteger i = 0; i <_subtitleIndexs.count; ++i) {
        int index = [_subtitleIndexs[i] intValue];
        if (index == currentSubTitleIndex) {
            [self.popButton selectItemAtIndex:i];
            break;
        }
    }
}

- (int)currentSubTitleIndex {
    return (int)self.popButton.indexOfSelectedItem;
}

#pragma mark - 私有方法
- (void)touchPopButton:(NSPopUpButton *)button {
    NSInteger index = button.indexOfSelectedItem;
    
    if (self.touchSubtitleIndexCallBack && index < self.subtitleIndexs.count) {
        self.touchSubtitleIndexCallBack([self.subtitleIndexs[index] intValue]);
    }
}

@end
