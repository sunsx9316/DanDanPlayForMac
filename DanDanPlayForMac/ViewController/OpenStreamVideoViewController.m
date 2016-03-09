//
//  OpenStreamVideoViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OpenStreamVideoViewController.h"
#import "OpenStreamVideoViewModel.h"
#import "PlayerViewController.h"
#import "StreamingVideoModel.h"

@interface OpenStreamVideoViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) OpenStreamVideoViewModel *vm;
@end

@implementation OpenStreamVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JHProgressHUD showWithMessage:kLoadMessage parentView:self.view];
    [self.vm refreshWithcompletionHandler:^(NSError *error) {
        [self.tableView reloadData];
        [JHProgressHUD disMiss];
    }];
}
- (IBAction)doubleClickRow:(NSTableView *)sender {
    NSInteger row = [sender selectedRow];
    if (![self.vm danmakuForRow:row]) return;
    
    [JHProgressHUD showWithMessage:kLoadMessage parentView:self.view];
    [self.vm getVideoURLAndDanmakuForRow:row completionHandler:^(StreamingVideoModel *videoModel, NSDictionary *danmakuDic, NSError *error) {
        [JHProgressHUD disMiss];
        
        if (error) return;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openStreamVCChooseOver" object:nil userInfo:@{@"videos":@[videoModel]}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:nil userInfo:danmakuDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:nil];
    }];
}

- (instancetype)initWithAid:(NSString *)aid danmakuSource:(NSString *)danmakuSource{
    if ((self = kViewControllerWithId(@"OpenStreamVideoViewController"))) {
        self.vm = [[OpenStreamVideoViewModel alloc] initWithAid:aid danmakuSource:danmakuSource];
    }
    return self;
}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    static NSString *cellName = @"videoNameCell";
    NSTableCellView *view = [tableView makeViewWithIdentifier:cellName owner:self];
    view.textField.stringValue = [self.vm videoNameForRow:row];
    return view;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.vm numOfVideos];
}
@end
