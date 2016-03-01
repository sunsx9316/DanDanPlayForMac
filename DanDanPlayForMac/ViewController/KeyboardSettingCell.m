//
//  KeyBoardSettingCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "KeyboardSettingCell.h"
#import "GetKeyViewController.h"
#import "NSButton+Tools.h"

@interface KeyboardSettingCell()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) NSMutableArray *keyMapArr;
@property (weak) IBOutlet NSButton *OKButton;

@end

@implementation KeyboardSettingCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tableView setDoubleAction:@selector(doubleAction:)];
    [self.OKButton setTitleColor:[NSColor colorWithRed:0.12 green:0.48 blue:0.98 alpha:1]];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.keyMapArr.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([tableColumn.identifier isEqualToString:@"actionCell"]) {
        NSDictionary *dic = self.keyMapArr[row];
        cell.textField.stringValue = dic[@"name"];
    }else if ([tableColumn.identifier isEqualToString:@"keyCell"]){
        NSDictionary *dic = self.keyMapArr[row];
        cell.textField.stringValue = dic[@"keyName"];
    }
    return cell;
}

- (void)doubleAction:(NSTableView *)tableView{
    NSInteger index = [tableView selectedRow];
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    NSMutableDictionary *dic = [self.keyMapArr[index] mutableCopy];
    [vc presentViewControllerAsModalWindow:[[GetKeyViewController alloc] initWithFunctionName:dic[@"name"] keyName:dic[@"keyName"] getBlock:^(NSString *keyName, NSUInteger keyCode, NSUInteger flag) {
        dic[@"keyName"] = keyName;
        dic[@"keyCode"] = @(keyCode);
        dic[@"flag"] = @(flag);
        self.keyMapArr[index] = dic;
        [self.tableView reloadData];
    }]];
}

- (IBAction)clickOKButton:(NSButton *)sender {
    [UserDefaultManager setCustomKeyMap:self.keyMapArr];
}

- (IBAction)clickDeleteButton:(NSButton *)sender {
    NSInteger index = [self.tableView selectedRow];
    NSMutableDictionary *dic = [self.keyMapArr[index] mutableCopy];
    dic[@"keyName"] = @"";
    dic[@"flag"] = @-1;
    dic[@"keyCode"] = @-1;
    self.keyMapArr[index] = dic;
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex: 1]];
}

- (IBAction)clickResetButton:(NSButton *)sender {
    [UserDefaultManager setCustomKeyMap: nil];
    self.keyMapArr = [UserDefaultManager customKeyMap];
    [self.tableView reloadData];
}


#pragma mark - 懒加载
- (NSMutableArray *)keyMapArr {
	if(_keyMapArr == nil) {
        _keyMapArr = [UserDefaultManager customKeyMap];
	}
	return _keyMapArr;
}

@end
