//
//  RecommendItemViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendItemViewController.h"
#import "RecommendBangumiCell.h"
#import "NSString+Tools.h"

@interface RecommendItemViewController ()
@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation RecommendItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setModel:(BangumiModel *)model {
    _model = model;
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    RecommendBangumiCell *cell = [tableView makeViewWithIdentifier:@"RecommendBangumiCell" owner:self];
    BangumiDataModel *model = self.model.bangumis[row];
    [cell setWithModel:model];
    [cell setClickGroupsButtonCallBack:^(BangumiGroupModel *model) {
        //替换URL
        NSString *url = model.searchURL;
        NSRange range = [url rangeOfString:OLD_PATH];
        if (range.location != NSNotFound) {
            NSMutableString *tempStr = [[NSMutableString alloc] initWithString:url];
            [tempStr replaceCharactersInRange:range withString:NEW_PATH];
            system([[NSString stringWithFormat:@"open %@", tempStr] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
    return cell;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.model.bangumis.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 80;
}

#pragma mark - 私有方法
- (IBAction)doubleClickTableView:(NSTableView *)sender {
    BangumiDataModel *model = self.model.bangumis[sender.selectedRow];
    NSString *keyWord = [model.name stringByURLEncode];
    system([NSString stringWithFormat:@"open %@%@", SEARCH_PATH, keyWord].UTF8String);
}



@end
