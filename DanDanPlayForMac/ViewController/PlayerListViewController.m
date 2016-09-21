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
#import "VideoModelProtocol.h"
#import "NSTableView+Tools.h"

@interface PlayerListViewController ()<NSTabViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSButton *cleanButton;
@end

@implementation PlayerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBAColor(0, 0, 0, 0.5);
    [self.cleanButton setTitleColor:[NSColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"VIDEO_DOWNLOAD_PROGRESS" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateProgress:(NSNotification *)aNotification {
    id<VideoModelProtocol>model = aNotification.object;
    NSUInteger index = [self.vm.videos indexOfObject:model];
    if (index < self.vm.videos.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRow:index inColumn:0];
        });
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.vm.videos.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    @weakify(self)
    //视频列表
    VideoNameCell *cell = [tableView makeViewWithIdentifier:@"VideoNameCell" owner:self];
    [cell setWithModel:[self.vm videoModelWithIndex:row] iconHide:(self.vm.currentIndex != row) callBack:^{
        @strongify(self)
        if (!self) return;
        
        if (self.deleteRowCallBack) {
            self.deleteRowCallBack(row);
        }
        [self.vm removeVideoAtIndex:row];
        [self.tableView reloadData];
    }];
    return cell;
    
}

#pragma mark - NSTabViewDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 30;
}

#pragma mark - 私有方法
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

- (void)startPlayNotice:(NSNotification *)sender {
    
}

@end
