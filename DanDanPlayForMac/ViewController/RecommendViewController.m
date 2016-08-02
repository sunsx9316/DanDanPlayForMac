//
//  RecommendViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommedViewModel.h"

#import "RecommendHeadCell.h"
#import "RecommendBangumiCell.h"

@interface RecommendViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) RecommedViewModel *vm;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressHUD show];
    [self.vm refreshWithCompletionHandler:^(NSError *error) {
        [self.progressHUD disMiss];
        [self.tableView reloadData];
    }];
}

- (instancetype)init{
    if ((self = kViewControllerWithId(@"RecommendViewController"))) {
        self.title = @"番剧推荐";
    }
    return self;
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    if (row == 0) {
        RecommendHeadCell *headCell = [tableView makeViewWithIdentifier:@"RecommendHeadCell" owner:self];
        [headCell setWithTitle:[self.vm headTitle] info: [self.vm headCategory] brief:[self.vm headIntroduction] imgURL:[self.vm headImgURL] FilmReviewURL:[self.vm headFileReviewURL]];
        return headCell;
    }
    RecommendBangumiCell *cell = [tableView makeViewWithIdentifier:@"RecommendBangumiCell" owner:self];
    [cell setWithTitle:[self.vm titleForRow:row] keyWord:[self.vm keyWordForRow:row] imgURL:[self.vm imgURLForRow:row] captionsGroup:[self.vm groupsForRow:row]];
    return cell;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.vm numOfRow];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    RecommendHeadCell *cell = (RecommendHeadCell *)[self tableView:tableView viewForTableColumn:nil row:row];
    if (row == 0) {
        return [cell cellHeight];
    }
    return 80;
}

#pragma mark - 懒加载
- (RecommedViewModel *)vm {
	if(_vm == nil) {
		_vm = [[RecommedViewModel alloc] init];
	}
	return _vm;
}

- (JHProgressHUD *)progressHUD {
	if(_progressHUD == nil) {
		_progressHUD = [[JHProgressHUD alloc] initWithMessage:[UserDefaultManager alertMessageWithKey:@"kLoadMessageString"] style:JHProgressHUDStyleValue1 parentView:self.view dismissWhenClick:NO];
	}
	return _progressHUD;
}


@end
