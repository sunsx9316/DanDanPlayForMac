//
//  PlayerDanmakuViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerDanmakuViewController.h"

#import "VideoNameCell.h"
#import "HideDanMuAndCloseCell.h"
#import "SliderControlCell.h"
#import "TimeAxisCell.h"
#import "OnlyButtonCell.h"

@interface PlayerDanmakuViewController ()<NSTabViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation PlayerDanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)startPlayNotice:(NSNotification *)sender {
    
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 7;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //弹幕控制列表
    if (row == 0) {
        HideDanMuAndCloseCell *cell = [tableView makeViewWithIdentifier:@"HideDanMuAndCloseCell" owner: self];
        cell.selectBlock = self.hideDanMuAndCloseCallBack;
        return cell;
    }
    else if (row == 1) {
        SliderControlCell *cell = [tableView makeViewWithIdentifier:@"SliderControlCell" owner:self];
        [cell setWithBlock:self.adjustDanmakuFontSizeCallBack sliderControlStyle:sliderControlStyleFontSize];
        return cell;
    }
    else if (row == 2) {
        SliderControlCell *cell = [tableView makeViewWithIdentifier:@"SliderControlCell" owner:self];
        [cell setWithBlock:self.adjustDanmakuSpeedCallBack sliderControlStyle:sliderControlStyleSpeed];
        return cell;
    }
    else if (row == 3) {
        SliderControlCell *cell = [tableView makeViewWithIdentifier:@"SliderControlCell" owner:self];
        [cell setWithBlock:self.adjustDanmakuSpeedCallBack sliderControlStyle:sliderControlStyleSpeed];
        [cell setWithBlock:self.adjustDanmakuOpacityCallBack sliderControlStyle:sliderControlStyleOpacity];
        return cell;
    }
    else if (row == 4) {
        TimeAxisCell * cell = [tableView makeViewWithIdentifier:@"TimeAxisCell" owner: self];
        cell.timeOffsetBlock = self.adjustDanmakuTimeOffsetCallBack;
        return cell;
    }
    else if (row == 5) {
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"重新选择弹幕";
        cell.buttonDownBlock = self.showSearchViewControllerCallBack;
        return cell;
    }
    else if (row == 6) {
        OnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OnlyButtonCell" owner:self];
        cell.button.title = @"加载本地弹幕";
        cell.buttonDownBlock = self.reloadLocaleDanmakuCallBack;
        return cell;
    }
    return nil;
}

#pragma mark - NSTabViewDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if (row == 0) {
        return 120;
    }
    else if (row == 4) {
        return 100;
    }
    return 60;
}
@end
