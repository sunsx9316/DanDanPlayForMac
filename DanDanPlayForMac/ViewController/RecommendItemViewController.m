//
//  RecommendItemViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendItemViewController.h"
#import "RecommendBangumiCell.h"

@interface RecommendItemViewController ()
@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation RecommendItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (instancetype)init {
    return kViewControllerWithId(@"RecommendItemViewController");
}

- (void)setModel:(BangumiModel *)model {
    _model = model;
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    RecommendBangumiCell *cell = [tableView makeViewWithIdentifier:@"RecommendBangumiCell" owner:self];
    [cell setWithModel:self.model.bangumis[row]];
    return cell;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.model.bangumis.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 80;
}


@end
