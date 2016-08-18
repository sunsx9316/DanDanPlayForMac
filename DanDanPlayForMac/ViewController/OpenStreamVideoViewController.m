//
//  OpenStreamVideoViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OpenStreamVideoViewController.h"
#import "PlayerViewController.h"
#import "OpenStreamVideoViewModel.h"
#import "StreamingVideoModel.h"
#import "OpenStreamVideoCheakCell.h"
#import "HUDMessageView.h"

@interface OpenStreamVideoViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *selectedAllButton;
@property (strong, nonatomic) OpenStreamVideoViewModel *vm;
@property (strong, nonatomic) NSMutableSet *selectedSet;
@property (strong, nonatomic) HUDMessageView *messageView;
@end

@implementation OpenStreamVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JHProgressHUD showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView:self.view];
    [self.vm refreshWithcompletionHandler:^(NSError *error) {
        [self.tableView reloadData];
        [JHProgressHUD disMiss];
        if (error) {
            
            [self.messageView showHUD];
        }
    }];
}

- (IBAction)clickRow:(NSTableView *)sender {
    NSInteger selectRow = [sender selectedRow];
    if (selectRow < [self.vm numOfVideos]) {
        if ([self.selectedSet containsObject:@(selectRow)]) {
            [self.selectedSet removeObject:@(selectRow)];
        }else{
            [self.selectedSet addObject:@(selectRow)];
        }
    }
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:selectRow] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}

- (IBAction)clickSelectedAllButton:(NSButton *)sender {
    NSInteger count = [self.vm numOfVideos];
    if (sender.state) {
        for (NSInteger i = 0; i < count; ++i) {
            [self.selectedSet addObject:@(i)];
        }
    }else{
        [self.selectedSet removeAllObjects];
    }
    [self.tableView reloadData];
}

- (IBAction)clickReverseButton:(NSButton *)sender {
    NSInteger count = [self.vm numOfVideos];
    for (NSInteger i = 0; i < count; ++i) {
        if ([self.selectedSet containsObject:@(i)]) {
            [self.selectedSet removeObject:@(i)];
        }else{
            [self.selectedSet addObject:@(i)];
        }
    }
    self.selectedAllButton.state = self.selectedSet.count == count;
    [self.tableView reloadData];
}

- (IBAction)clickOKButton:(NSButton *)sender {
    __block NSInteger i = [[self.selectedSet anyObject] integerValue];
    //选出最小者
    [self.selectedSet enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        NSInteger intValue = [obj integerValue];
        if (i > intValue) i = intValue;
    }];
    [self streamingVideoModelWithRow:i];
}

- (IBAction)clickBackButton:(NSButton *)sender {
    [self dismissViewController:self];
}


- (instancetype)initWithAid:(NSString *)aid danmakuSource:(DanDanPlayDanmakuSource)danmakuSource {
    if ((self = kViewControllerWithId(@"OpenStreamVideoViewController"))) {
        self.vm = [[OpenStreamVideoViewModel alloc] initWithAid:aid danmakuSource:danmakuSource];
    }
    return self;
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    static NSString *cellName = @"OpenStreamVideoCheakCell";
    OpenStreamVideoCheakCell *button = [tableView makeViewWithIdentifier:cellName owner:self];
    button.state = [self.selectedSet containsObject:@(row)];
    __weak typeof(self)weakSelf = self;
    [button setWithTitle:[self.vm videoNameForRow:row] callBackHandle:^(NSInteger state) {
        state ? [weakSelf.selectedSet addObject:@(row)]:[weakSelf.selectedSet removeObject:@(row)];
        weakSelf.selectedAllButton.state = weakSelf.selectedSet.count == [weakSelf.vm numOfVideos];
    }];
    return button;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.vm numOfVideos];
}

#pragma mark - 私有方法
- (void)streamingVideoModelWithRow:(NSInteger)row{
    if (![self.vm danmakuForRow:row].length) return;
    
    [JHProgressHUD showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView:self.view];
    [self.vm getVideoURLAndDanmakuForRow:row completionHandler:^(StreamingVideoModel *videoModel, NSError *error) {
        [JHProgressHUD disMiss];
        
        if (error) {
            [self.messageView showHUD];
            return;
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithObject:videoModel];
        NSInteger videoCount = [self.vm numOfVideos];
        for (NSInteger i = 0; i < videoCount; ++i) {
            if ([self.selectedSet containsObject:@(i)] && row != i) {
                StreamingVideoModel *tvm = [[StreamingVideoModel alloc] initWithFileURLs:nil fileName:[self.vm videoNameForRow:i] danmaku:[self.vm danmakuForRow:i] danmakuSource:videoModel.danmakuSource];
                [arr addObject:tvm];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OPEN_STREAM_VC_CHOOSE_OVER" object:nil userInfo:@{@"videos":arr}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:nil userInfo:videoModel.danmakuDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISSMISS_VIEW_CONTROLLER" object:nil];
        
    }];
}
- (NSMutableSet *)selectedSet {
	if(_selectedSet == nil) {
		_selectedSet = [[NSMutableSet alloc] init];
	}
	return _selectedSet;
}

- (HUDMessageView *)messageView {
	if(_messageView == nil) {
		_messageView = [[HUDMessageView alloc] init];
        _messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDanmaku].message;
	}
	return _messageView;
}

@end
