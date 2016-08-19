//
//  PlayerListViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerListViewController.h"
#import "VideoNameCell.h"
#import "NSButton+Tools.h"

@interface PlayerListViewController ()<NSTabViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSButton *cleanButton;
@end

@implementation PlayerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = RGBAColor(0, 0, 0, 0.5).CGColor;
    [self.cleanButton setTitleColor:[NSColor whiteColor]];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.vm videoCount];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    __weak typeof(self)weakSelf = self;
    //视频列表
    VideoNameCell *cell = [tableView makeViewWithIdentifier:@"VideoNameCell" owner:self];
    [cell setTitle:[self.vm videoNameWithIndex:row] iconHide:[self.vm showPlayIconWithIndex:row] callBack:^{
        if (self.deleteRowCallBack) {
            self.deleteRowCallBack(row);
        }
        [weakSelf.vm removeVideoAtIndex:row];
        [weakSelf.tableView reloadData];
    }];
    return cell;
    
}

#pragma mark - NSTabViewDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 30;
}

//双击行
- (IBAction)doubleClickRow:(NSTableView *)sender {
    NSUInteger selectedIndex = [sender selectedRow];
    if (self.doubleClickRowCallBack) {
        self.doubleClickRowCallBack(selectedIndex);
    }
}
//点击清除历史按钮
- (IBAction)touchCleanAllHistoryButton:(NSButton *)sender {
    [self.vm removeVideoAtIndex:-1];
    [self.tableView reloadData];
}


@end
