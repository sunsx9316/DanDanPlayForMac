//
//  MatchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "MatchViewController.h"
#import "MatchViewModel.h"
#import "LocalVideoModel.h"
#import "SearchViewController.h"
#import "JHProgressHUD.h"

@interface MatchViewController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSSearchField *searchField;



@property (strong, nonatomic) MatchViewModel *vm;
@property (strong, nonatomic) LocalVideoModel *videoModel;
@end

@implementation MatchViewController

#pragma mark - 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMissSelf) name:@"disMissViewController" object: nil];
    
    [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" style:value1 parentView:self.view dismissWhenClick: YES];
    
    [self.vm refreshWithModelCompletionHandler:^(NSError *error) {
        [JHProgressHUD disMiss];
        [self.tableView reloadData];
    }];
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)initWithStoryboardID:(NSString *)StoryboardID videoModel:(LocalVideoModel *)videoModel{
    if ((self = kViewControllerWithId(StoryboardID))) {
        self.videoModel = videoModel;
        self.vm = [[MatchViewModel alloc] initWithModel: videoModel];
    }
    return self;
}

- (IBAction)searchButtonDown:(NSButton *)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchText = self.searchField.stringValue;
    [self presentViewControllerAsSheet: vc];
}
- (IBAction)backButtonDown:(NSButton *)sender {
    [self dismissController: self];
}

#pragma mark - 私有方法

- (void)disMissSelf{
    [self dismissController: self];
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
