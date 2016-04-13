//
//  PreferenceViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//


#import "PreferenceViewController.h"
#import "PreferenceViewModel.h"

#import "DanMuFastMatchCell.h"
#import "FontSpeciallyCell.h"
#import "SliderWithTickCell.h"
#import "ChangeFontCell.h"
#import "CaptionsProtectAreaCell.h"
#import "ChangeBackGroundImgCell.h"
#import "DanMuFilterCell.h"
#import "KeyboardSettingCell.h"
#import "ScreenShotCell.h"
#import "CacheManagerCell.h"
#import "OtherOnlyButtonCell.h"
#import "QualityCell.h"
#import "NSAlert+Tools.h"

@interface PreferenceViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate, NSTableViewDataSource, NSSplitViewDelegate>
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) PreferenceViewModel *vm;
@property (assign, nonatomic) preferenceTableViewStyle tableViewStyle;
@end

@implementation PreferenceViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.outlineView setAction: @selector(clickOutlineView)];
    [self.splitView setPosition:200 ofDividerAtIndex: 0];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    return self.view.frame.size.width / 2;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
    return 20;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.vm numOfRowWithStyle: self.tableViewStyle];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    switch (self.tableViewStyle) {
        case preferenceTableViewStyleDamaku:
            return [self danMuSurfaceTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStylePlayer:
            return [self playerTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStyleFilter:
            return [self filterTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStyleKeyboard:
            return [self keyboardTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStyleScreenShot:
            return [self screenShotTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStyleCache:
            return [self cacheTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStyleUpdate:
            return [self updateTableView:tableView viewForTableColumn:tableColumn row:row];
        case preferenceTableViewStyleOther:
            return [self otherTableView:tableView viewForTableColumn:tableColumn row:row];
        default:
            break;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    switch (self.tableViewStyle) {
        case preferenceTableViewStyleDamaku:
            if (row == 0) return 132;
            else if (row == 1 || row == 2) return 108;
            else if (row == 3) return 88;
            else if (row == 4) return 79;
            else if (row == 5) return 79;
            break;
        case preferenceTableViewStylePlayer:
            return 300;
        case preferenceTableViewStyleFilter:
        case preferenceTableViewStyleKeyboard:
            return 500;
        case preferenceTableViewStyleScreenShot:
            return 119;
        case preferenceTableViewStyleCache:
            return 91;
        case preferenceTableViewStyleUpdate:
            return 107;
        case preferenceTableViewStyleOther:
            return 87;
        default:
            break;
    }
    return 0;
}


#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item{
    return [self.vm numberOfTitle];
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item{
    return [self.vm titleForRow: index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    return NO;
}

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *result = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    result.textField.stringValue = item;
    return result;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
    return 40;
}

#pragma mark - 私有方法

- (void)clickOutlineView{
    self.tableViewStyle = [self.outlineView selectedRow];
    [self.tableView reloadData];
}
- (IBAction)clickBackButton:(NSButton *)sender {
    [self dismissViewController:self];
}

- (NSView *)danMuSurfaceTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    switch (row) {
        case 0:
        {
            FontSpeciallyCell *cell = [tableView makeViewWithIdentifier:@"FontSpeciallyCell" owner:self];
            return cell;
        }
        case 1:
        {
            SliderWithTickCell *cell = [tableView makeViewWithIdentifier:@"SliderWithTickCell" owner:self];
            cell.titleTextField.stringValue = @"弹幕速度";
            cell.detailTextField.stringValue = @"设置普通弹幕移动速度";
            [cell setUpDefauleValueWithStyle: sliderWithTickCellStyleSpeed];
            return cell;
        }
        case 2:
        {
            SliderWithTickCell *cell = [tableView makeViewWithIdentifier:@"SliderWithTickCell" owner:self];
            cell.titleTextField.stringValue = @"透明度";
            cell.detailTextField.stringValue = @"设置弹幕透明度";
            [cell setUpDefauleValueWithStyle: sliderWithTickCellStyleOpacity];
            return cell;
        }
        case 3:
        {
            ChangeFontCell *cell = [tableView makeViewWithIdentifier:@"ChangeFontCell" owner:self];
            return cell;
        }
        case 4:
        {
            CaptionsProtectAreaCell *cell = [tableView makeViewWithIdentifier:@"CaptionsProtectAreaCell" owner:self];
            return cell;
        }
        case 5:
        {
            DanMuFastMatchCell *cell = [tableView makeViewWithIdentifier:@"DanMuFastMatchCell" owner:self];
            return cell;
        }
    }
    return nil;
}

- (NSView *)playerTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableView makeViewWithIdentifier:@"ChangeBackGroundImgCell" owner:self];
}

- (NSView *)filterTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableView makeViewWithIdentifier:@"DanMuFilterCell" owner:self];
}

- (NSView *)keyboardTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableView makeViewWithIdentifier:@"KeyboardSettingCell" owner:self];
}

- (NSView *)screenShotTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableView makeViewWithIdentifier:@"ScreenShotCell" owner:self];
}

- (NSView *)cacheTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableView makeViewWithIdentifier:@"CacheManagerCell" owner:self];
}

- (NSView *)updateTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableView makeViewWithIdentifier:@"AutoUpdateCell" owner:self];
}

- (NSView *)otherTableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    switch (row) {
        case 0:
            return [tableView makeViewWithIdentifier:@"OtherSettingCell" owner:self];
        case 1:
        {
           OtherOnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OtherOnlyButtonCell" owner:self];
            [cell setWithTitle:@"清除上次播放时间纪录" info:@"难道你想隐藏什么→_→" buttonText:@"清除播放时间纪录"];
            [cell setClickButtonCallBackBlock:^{
                [UserDefaultManager clearPlayHistory];
                NSAlert *alert = [NSAlert alertWithMessageText:@"清除成功" informativeText:nil];
                [alert runModal];
            }];
            return cell;
        }
        case 2:
            return [tableView makeViewWithIdentifier:@"QualityCell" owner:self];
        case 3:
        {
            OtherOnlyButtonCell *cell = [tableView makeViewWithIdentifier:@"OtherOnlyButtonCell" owner:self];
            [cell setWithTitle:@"恢复默认设置" info:@"就是恢复默认设置" buttonText:@"恢复默认设置"];
            [cell setClickButtonCallBackBlock:^{
                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                NSAlert *alert = [NSAlert alertWithMessageText:kResetSuccessString informativeText:kResetSuccessInformativeString];
                [alert runModal];
            }];
            return cell;
        }
            
    }
    return nil;
}

#pragma mark - 懒加载
- (PreferenceViewModel *)vm {
	if(_vm == nil) {
		_vm = [[PreferenceViewModel alloc] init];
	}
	return _vm;
}

@end
