//
//  MatchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "MatchViewController.h"
#import "SearchViewController.h"
#import "DanMuChooseViewController.h"
#import "MatchViewModel.h"
#import "LocalVideoModel.h"
#import "MatchModel.h"

@interface MatchViewController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSSearchField *searchField;

@property (strong, nonatomic) MatchViewModel *vm;
@end

@implementation MatchViewController

#pragma mark - 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchField.stringValue = [self.vm videoName];
    [self.tableView setDoubleAction: @selector(doubleClickRow)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMissSelf) name:@"disMissViewController" object: nil];
    
    [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView:self.view];
    
    [self.vm refreshWithModelCompletionHandler:^(NSError *error, MatchDataModel *model) {
        //episodeId存在 说明精确匹配
        [JHProgressHUD disMiss];
        if (model.episodeId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mathchVideo" object:self userInfo:@{@"animateTitle":[NSString stringWithFormat:@"%@-%@", model.animeTitle, model.episodeTitle]}];
            [self presentViewControllerAsSheet: [[DanMuChooseViewController alloc] initWithVideoID: model.episodeId]];
        }else{
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)initWithVideoModel:(LocalVideoModel *)videoModel{
    if ((self = kViewControllerWithId(@"MatchViewController"))) {
        self.vm = [[MatchViewModel alloc] initWithModel: videoModel];
    }
    return self;
}

- (IBAction)searchButtonDown:(NSButton *)sender {
    if (!self.searchField.stringValue || [self.searchField.stringValue isEqualToString: @""]) return;
    
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchText = self.searchField.stringValue;
    [self presentViewControllerAsSheet: vc];
}
- (IBAction)backButtonDown:(NSButton *)sender {
    [self dismissController: self];
    //通知开始播放
    [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:self userInfo: nil];
}

#pragma mark - 私有方法

- (void)disMissSelf{
    [self dismissController: self];
}

- (void)doubleClickRow{
    NSString *episodeID = [self.vm modelEpisodeIdWithIndex: [self.tableView clickedRow]];
    if (episodeID) {
            DanMuChooseViewController *vc = [[DanMuChooseViewController alloc] initWithVideoID: episodeID];
            [self presentViewControllerAsSheet: vc];
        }
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.vm modelCount];
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([tableColumn.identifier isEqualToString: @"col1"]) {
        result.textField.stringValue = [self.vm modelAnimeTitleIdWithIndex: row];
    }else{
        result.textField.stringValue = [self.vm modelEpisodeTitleWithIndex: row];
    }
    return result;
}

@end
