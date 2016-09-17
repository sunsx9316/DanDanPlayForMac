//
//  PlayerSubtitleViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/19.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSubtitleViewController.h"
#import "PlayerSubtitleTimeOffsetCell.h"
#import "OnlyButtonCell.h"
#import "PlayerSubtitleSwitchCell.h"

@interface PlayerSubtitleViewController ()<NSTableViewDataSource, NSTabViewDelegate>

@end

@implementation PlayerSubtitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)startPlayNotice:(NSNotification *)sender {
    
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 3;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row == 0) {
        PlayerSubtitleSwitchCell *cell = [tableView makeViewWithIdentifier:@"PlayerSubtitleSwitchCell" owner:nil];
        cell.subtitleIndexs = self.subtitleIndexs;
        cell.subtitleTitles = self.subtitleTitles;
        cell.touchSubtitleIndexCallBack = self.touchSubtitleIndexCallBack;
        cell.currentSubTitleIndex = self.currentSubtitleIndex;
        return cell;
    }
    else if (row == 1) {
        PlayerSubtitleTimeOffsetCell *cell = [tableView makeViewWithIdentifier:@"PlayerSubtitleTimeOffsetCell" owner:self];
        cell.timeOffsetCallBack = self.timeOffsetCallBack;
        return cell;
    }
    else if (row == 2) {
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"选择本地字幕文件";
        cell.buttonDownBlock = self.chooseLoactionFileCallBack;
        return cell;
    }
    return nil;
}

#pragma mark - NSTabViewDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if (row == 0) {
        return 55;
    }
    else if (row == 1) {
        return 102;
    }
    else if (row == 2) {
        return 50;
    }
    return 0;
}


@end
