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
    [[UserDefaultManager shareUserDefaultManager] addObserver:self forKeyPath:@"showRecommedInfoAtStart" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [[UserDefaultManager shareUserDefaultManager] removeObserver:self forKeyPath:@"showRecommedInfoAtStart"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    self.showRecommedVCButton.state = [change[@"new"] integerValue];
}

- (IBAction)clickShowRecommedVC:(NSButton *)sender {
    [[NSApp mainWindow].contentViewController presentViewControllerAsModalWindow:[RecommendViewController viewController]];
}

- (IBAction)clickAutoShowRecommedVCOnStartButton:(NSButton *)sender {
    [[UserDefaultManager shareUserDefaultManager] setShowRecommedInfoAtStart:sender.state];
}


@end
