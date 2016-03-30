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
#import "RespondKeyboardSearchField.h"
#import "MatchViewModel.h"
#import "LocalVideoModel.h"
#import "MatchModel.h"

@interface MatchViewController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet RespondKeyboardSearchField *searchField;

@property (strong, nonatomic) MatchViewModel *vm;
@end

@implementation MatchViewController

#pragma mark - 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self)weakSelf = self;
    self.searchField.stringValue = [self.vm videoName];
    [self.searchField setRespondBlock:^{
        [weakSelf searchButtonDown:nil];
    }];
    
    [self.tableView setDoubleAction: @selector(doubleClickRow)];
    
    [JHProgressHUD showWithMessage:kLoadMessage parentView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMissSelf:) name:@"DISSMISS_VIEW_CONTROLLER" object: nil];
    
    [self.vm refreshWithModelCompletionHandler:^(NSError *error, MatchDataModel *model) {
        //episodeId存在 说明精确匹配
        [JHProgressHUD disMiss];
        if (model.episodeId && [UserDefaultManager turnOnFastMatch]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MATCH_VIDEO" object:self userInfo:@{@"animateTitle":[NSString stringWithFormat:@"%@-%@", model.animeTitle, model.episodeTitle]}];
                [self presentViewControllerAsSheet: [[DanMuChooseViewController alloc] initWithVideoID: model.episodeId]];
        }else{
            [self.tableView reloadData];
        }
    }];
    
}

- (void)dealloc{
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:self userInfo: nil];
}

#pragma mark - 私有方法

- (void)disMissSelf:(NSNotification *)notification{
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
