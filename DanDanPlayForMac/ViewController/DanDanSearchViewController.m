//
//  DanDanSearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/31.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanDanSearchViewController.h"
#import "DanmakuChooseViewController.h"
#import "SearchViewModel.h"
#import "SearchModel.h"
#import "HUDMessageView.h"

@interface DanDanSearchViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (strong, nonatomic) SearchViewModel *vm;
@property (strong, nonatomic) JHProgressHUD *hud;
@property (strong, nonatomic) HUDMessageView *messageView;
@end

@implementation DanDanSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.outlineView setDoubleAction: @selector(doubleClickRow)];
    [self refreshBykeyword];
}

#pragma mark - 私有方法
- (void)refreshBykeyword {
    [self.hud showWithView:self.view];
    [self.vm refreshWithKeyword:_keyword completionHandler:^(NSError *error) {
        if (error) {
            [self.messageView showHUD];
        }
        
        [self.hud hideWithCompletion:nil];
        [self.outlineView reloadData];
    }];
}

- (void)doubleClickRow {
    EpisodesModel *aModel = [self.outlineView itemAtRow: [self.outlineView selectedRow]];
    if ([aModel isKindOfClass: [EpisodesModel class]]) {
        NSString *videoID = aModel.Id;
        if (videoID.length) {
            DanmakuChooseViewController *vc = [DanmakuChooseViewController viewController];
            vc.videoId = videoID;
            [self presentViewControllerAsSheet: vc];
        }
    }
}

#pragma setter getter
- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    //避免重复请求
    if (self.isViewLoaded) {
        [self refreshBykeyword];
    }
}

#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item {
    //item存在时
    if (item) {
        //item是数组
        if ([item isKindOfClass: [NSArray class]] || [item isKindOfClass: [NSDictionary class]]) {
            return [item count];
        }
        //item不是数组
        else if ([item isKindOfClass: [SearchDataModel class]]){
            return [item episodes].count;
        }
        return 0;
    }
    //item不存在 说明为根节点
    return  [self.vm.models count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item {
    if (item) {
        if ([item isKindOfClass: [NSDictionary class]])
            return [[[item allValues] firstObject] objectAtIndex: index];
        else if ([item isKindOfClass: [NSArray class]])
            return item[index];
        else if ([item isKindOfClass: [SearchDataModel class]])
            return [[item episodes] objectAtIndex: index];
    }
    return self.vm.models[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    if (item) {
        if ([item isKindOfClass: [NSArray class]] || [item isKindOfClass: [NSDictionary class]])
            return [item count];
        else if ([item isKindOfClass: [SearchDataModel class]])
            return [item episodes].count;
    }
    return NO;
}

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *view = [outlineView makeViewWithIdentifier:@"cell" owner:self];
    if ([item isKindOfClass: [NSDictionary class]]) {
        view.textField.text = [item allKeys].firstObject;
    }
    else if ([item isKindOfClass: [SearchDataModel class]] || [item isKindOfClass: [EpisodesModel class]]) {
        view.textField.text = [item title];
    }
    return view;
}

#pragma mark - 懒加载
- (SearchViewModel *)vm {
	if(_vm == nil) {
		_vm = [[SearchViewModel alloc] init];
	}
	return _vm;
}

- (JHProgressHUD *)hud {
    if(_hud == nil) {
        _hud = [[JHProgressHUD alloc] init];
        _hud.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message;
        _hud.hideWhenClick = NO;
    }
    return _hud;
}

- (HUDMessageView *)messageView {
    if(_messageView == nil) {
        _messageView = [[HUDMessageView alloc] init];
        _messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeConnectFail].message;
    }
    return _messageView;
}

@end
