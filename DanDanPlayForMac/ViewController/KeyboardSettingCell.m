//
//  KeyBoardSettingCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "KeyboardSettingCell.h"
#import "ColorButton.h"
#import "NSString+KeyEvent.h"
#import "NSTableView+Tools.h"

@interface KeyboardSettingCell()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) NSMutableArray *keyMapArr;
@property (strong, nonatomic) NSArray <NSValue *>*associatedKeyArr;
@end

@implementation KeyboardSettingCell
{
    //当前双击行
    NSUInteger _currentDoubleSelectRow;
    BOOL _capsLockOn;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _currentDoubleSelectRow = -1;
    self.tableView.allowsTypeSelect = NO;
    [self.tableView setDoubleAction:@selector(doubleAction:)];
    [self.tableView setAction:@selector(clickedRow:)];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.keyMapArr.count;
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([tableColumn.identifier isEqualToString:@"actionCell"]) {
        NSDictionary *dic = self.keyMapArr[row];
        cell.textField.text = dic[@"name"];
    }
    else if ([tableColumn.identifier isEqualToString:@"keyCell"]){
        NSDictionary *dic = self.keyMapArr[row];
        NSString *key = dic[@"keyName"];
        cell.textField.text = key;
    }
    return cell;
}

#pragma mark - 私有方法
- (void)doubleAction:(NSTableView *)tableView {
    NSInteger index = tableView.selectedRow;
    _currentDoubleSelectRow = index;
    
    if (index < self.keyMapArr.count) {
        NSMutableDictionary *dic = self.keyMapArr[index];
        NSString *key = [dic[@"keyName"] copy];
        //关联对象 保存键值
        objc_setAssociatedObject(self.keyMapArr[index], [self.associatedKeyArr[index] pointerValue], key, OBJC_ASSOCIATION_RETAIN);
        dic[@"keyName"] = @"";
        [tableView reloadRow:index inColumn:1];
    }
}

- (void)clickedRow:(NSTableView *)tableView {
    NSUInteger currentIndex = _currentDoubleSelectRow;
    _currentDoubleSelectRow = -1;
    
    if (currentIndex < self.keyMapArr.count) {
        NSMutableDictionary *dic = self.keyMapArr[currentIndex];
        //按关联值恢复key
        NSString *key = objc_getAssociatedObject(dic, [self.associatedKeyArr[currentIndex] pointerValue]);
        if (key.length) {
            dic[@"keyName"] = key;
        }
        [tableView reloadRow:currentIndex inColumn:1];
    }
}

- (IBAction)clickDeleteButton:(NSButton *)sender {
    NSUInteger index = [self.tableView selectedRow];
    if (index < self.keyMapArr.count) {
        NSMutableDictionary *dic = self.keyMapArr[index];
        dic[@"keyName"] = @"";
        dic[@"flag"] = @-1;
        dic[@"keyCode"] = @-1;
        [UserDefaultManager shareUserDefaultManager].customKeyMapArr = self.keyMapArr;
        [self.tableView reloadRow:index inColumn:1];        
    }
}

- (IBAction)clickResetButton:(NSButton *)sender {
    [[UserDefaultManager shareUserDefaultManager] setCustomKeyMapArr:nil];
    self.keyMapArr = nil;
    [self.tableView reloadData];
}

- (void)flagsChanged:(NSEvent *)event{
    if ([event keyCode] == 0x39){
        NSUInteger flags = [event modifierFlags];
        _capsLockOn = flags & NSAlphaShiftKeyMask;
    }
}

- (void)keyUp:(NSEvent *)theEvent {
    if (_currentDoubleSelectRow >= self.keyMapArr.count) return;
    
    NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 17; i <= 20; ++i) {
        int temp = flags >> i & 1;
        if (temp) {
            switch (i) {
                case 17:
                    [str appendString:@"⇧ "];
                    break;
                case 18:
                    [str appendString:@"⌃ "];
                    break;
                case 19:
                    [str appendString:@"⌥ "];
                    break;
                case 20:
                    [str appendString:@"⌘ "];
                    break;
                default:
                    break;
            }
        }
    }
    
    [str appendString:[NSString stringWithKeyEventCharactersIgnoringModifiers:theEvent]];
    NSMutableDictionary *dic = self.keyMapArr[_currentDoubleSelectRow];
    objc_removeAssociatedObjects(dic);
    dic[@"keyName"] = str;
    dic[@"keyCode"] = @(theEvent.keyCode);
    dic[@"flag"] = @(flags - _capsLockOn * NSAlphaShiftKeyMask);
    [UserDefaultManager shareUserDefaultManager].customKeyMapArr = self.keyMapArr;
    [self.tableView reloadRow:_currentDoubleSelectRow inColumn:1];
    _currentDoubleSelectRow = -1;
}

#pragma mark - 懒加载
- (NSMutableArray *)keyMapArr {
	if(_keyMapArr == nil) {
        _keyMapArr = [UserDefaultManager shareUserDefaultManager].customKeyMapArr;
	}
	return _keyMapArr;
}

- (NSArray <NSValue *>*)associatedKeyArr {
	if(_associatedKeyArr == nil) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSInteger count = self.keyMapArr.count;
        for (NSInteger i = 0; i < count; ++i) {
            [tempArr addObject:[NSValue valueWithPointer:[NSString stringWithFormat:@"%ld", i].UTF8String]];
        }
		_associatedKeyArr = tempArr;
	}
	return _associatedKeyArr;
}

@end
