//
//  MatchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "MatchViewController.h"
#import "SearchViewController.h"
#import "DanmakuChooseViewController.h"
#import "RespondKeyboardSearchField.h"
#import "MatchViewModel.h"
#import "MatchModel.h"
#import "LocalVideoModel.h"

@interface MatchViewController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet RespondKeyboardSearchField *searchField;
@property (strong, nonatomic) MatchViewModel *vm;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.searchField.text = self.vm.videoModel.fileName;
    [self.searchField setRespondBlock:^{
        @strongify(self)
        if (!self) return;
        [self searchButtonDown:nil];
    }];
    
    [self.tableView setDoubleAction: @selector(doubleClickRow)];
    [self.progressHUD showWithView:self.view];
    [self.vm refreshWithCompletionHandler:^(NSError *error, MatchDataModel *model) {
        //episodeId存在 说明精确匹配
        [self.progressHUD hideWithCompletion:nil];
        if (model.episodeId && [UserDefaultManager shareUserDefaultManager].turnOnFastMatch) {
            //防止崩溃
            if (self == self.keyWindowsViewController) {
                id<VideoModelProtocol>vm = [UserDefaultManager shareUserDefaultManager].currentVideoModel;
                vm.matchTitle = [NSString stringWithFormat:@"%@-%@", model.animeTitle, model.episodeTitle];
                DanmakuChooseViewController *danmakuVC = [DanmakuChooseViewController viewController];
                danmakuVC.videoId = model.episodeId;
                [self presentViewControllerAsSheet: danmakuVC];
            }
        }
        else {
            [self.tableView reloadData];
        }
    }];
    
}

- (IBAction)searchButtonDown:(NSButton *)sender {
    if (!self.searchField.stringValue.length) return;
    
    SearchViewController *vc = [SearchViewController viewController];
    vc.searchText = self.searchField.stringValue;
    [self.presentingViewController presentViewControllerAsSheet: vc];
    [self dismissController:self];
}

- (IBAction)clickPlayButton:(NSButton *)sender {
    [self dismissController: self];
    //直接播放 不请求弹幕
    if (self.videoModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAY" object:@[self.videoModel]];
    }
}

- (IBAction)clickBackButton:(NSButton *)sender {
    [self dismissViewController:self];
}

#pragma mark - 私有方法
- (void)disMissSelf:(NSNotification *)notification {
    [self dismissController: self];
}

- (void)doubleClickRow {
    MatchDataModel *model = self.vm.models[self.tableView.clickedRow];
    NSString *episodeId = model.episodeId;
    if (episodeId.length) {
        DanmakuChooseViewController *vc = kViewControllerWithId(@"DanmakuChooseViewController");
        vc.videoId = episodeId;
        [self presentViewControllerAsSheet: vc];
    }
}

#pragma mark setter getter
- (void)setVideoModel:(LocalVideoModel *)videoModel {
    self.vm.videoModel = videoModel;
}

- (LocalVideoModel *)videoModel {
    return self.vm.videoModel;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.vm.models.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    MatchDataModel *model = self.vm.models[row];
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([tableColumn.identifier isEqualToString: @"col1"]) {
        result.textField.text = model.animeTitle;
    }
    else {
        result.textField.text = model.episodeTitle;
    }
    return result;
}

#pragma mark - 懒加载
- (MatchViewModel *)vm {
    if(_vm == nil) {
        _vm = [[MatchViewModel alloc] init];
    }
    return _vm;
}

- (JHProgressHUD *)progressHUD {
    if(_progressHUD == nil) {
        _progressHUD = [[JHProgressHUD alloc] init];
        _progressHUD.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message;
    }
    return _progressHUD;
}

@end
