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
#import "NOResponseButton.h"
#import "HUDMessageView.h"
#import "NSTableView+Tools.h"

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
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView:self.view];
    [self.vm refreshWithcompletionHandler:^(NSError *error) {
        [self.tableView reloadData];
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        if (error) {
            
            [self.messageView showHUD];
        }
    }];
}

- (IBAction)clickRow:(NSTableView *)sender {
    NSInteger selectRow = [sender selectedRow];
    if (selectRow < self.vm.models.count) {
        if ([self.selectedSet containsObject:@(selectRow)]) {
            [self.selectedSet removeObject:@(selectRow)];
        }
        else {
            [self.selectedSet addObject:@(selectRow)];
        }
    }
    self.selectedAllButton.state = self.selectedSet.count == self.vm.models.count;
    [self.tableView reloadRow:selectRow inColumn:0];
}

- (IBAction)clickSelectedAllButton:(NSButton *)sender {
    NSInteger count = self.vm.models.count;
    if (sender.state) {
        for (NSInteger i = 0; i < count; ++i) {
            [self.selectedSet addObject:@(i)];
        }
    }
    else {
        [self.selectedSet removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (IBAction)clickReverseButton:(NSButton *)sender {
    NSInteger count = self.vm.models.count;
    for (NSInteger i = 0; i < count; ++i) {
        if ([self.selectedSet containsObject:@(i)]) {
            [self.selectedSet removeObject:@(i)];
        }
        else {
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
    [self.presentingViewController dismissViewController:self];
}

+ (instancetype)viewControllerWithURL:(NSString *)URL danmakuSource:(DanDanPlayDanmakuSource)danmakuSource {
    OpenStreamVideoViewController *vc = [OpenStreamVideoViewController viewController];
    vc.vm = [[OpenStreamVideoViewModel alloc] initWithURL:URL danmakuSource:danmakuSource];
    return vc;
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    static NSString *cellName = @"OpenStreamVideoCheakCell";
    NOResponseButton *button = [tableView makeViewWithIdentifier:cellName owner:self];
    button.state = [self.selectedSet containsObject:@(row)];
    button.text = self.vm.models[row].title;
    return button;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.vm.models.count;
}

#pragma mark - 私有方法
- (void)streamingVideoModelWithRow:(NSInteger)row {
    if (!self.vm.models[row].danmaku.length) return;
    
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView:self.view];
    [self.vm getVideoURLAndDanmakuForRow:row completionHandler:^(StreamingVideoModel *videoModel, NSError *error) {
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        
        if (error) {
            [self.messageView showHUD];
            return;
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:videoModel, nil];
        NSInteger videoCount = self.vm.models.count;
        for (NSInteger i = 0; i < videoCount; ++i) {
            if ([self.selectedSet containsObject:@(i)] && row != i) {
                VideoInfoDataModel *vm = self.vm.models[i];
                StreamingVideoModel *aVM = [[StreamingVideoModel alloc] initWithFileURLs:nil fileName:vm.title danmaku:vm.danmaku danmakuSource:videoModel.danmakuSource];
                [arr addObject:aVM];
            }
        }
        
        [ToolsManager shareToolsManager].currentVideoModel = videoModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAY" object:arr];
    }];
}

- (void)startPlayNotice:(NSNotification *)sender {
    [super startPlayNotice:sender];
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
        _messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeVideoNoFound].message;
	}
	return _messageView;
}

@end
