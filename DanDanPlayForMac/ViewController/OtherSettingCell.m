//
//  OtherSettingCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OtherSettingCell.h"
#import "RecommendViewController.h"
@interface OtherSettingCell()
@property (weak) IBOutlet NSButton *showRecommedVCButton;

@end

@implementation OtherSettingCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.showRecommedVCButton.state = [UserDefaultManager shareUserDefaultManager].showRecommedInfoAtStart;
}

- (IBAction)clickShowRecommedVC:(NSButton *)sender {
    [[NSApp mainWindow].contentViewController presentViewControllerAsModalWindow:[[RecommendViewController alloc] init]];
}

- (IBAction)clickAutoShowRecommedVCOnStartButton:(NSButton *)sender {
    [[UserDefaultManager shareUserDefaultManager] setShowRecommedInfoAtStart:sender.state];
}


@end
