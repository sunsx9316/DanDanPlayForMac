//
//  ThirdPartySearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartySearchViewController.h"
#import "ThirdPartyDanMuChooseViewController.h"
#import "BiliBiliSearchViewModel.h"
#import "AcFunSearchViewModel.h"

@interface ThirdPartySearchViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSImageView *coverImageView;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTextField *detailTextField;
@property (strong, nonatomic) ThirdPartySearchViewModel *vm;
@end

@implementation ThirdPartySearchViewController

- (instancetype)initWithType:(kDanMuSource)type{
    if ((self = kViewControllerWithId(@"ThirdPartySearchViewController"))) {
        if (type == bilibili) {
            self.vm = [BiliBiliSearchViewModel new];
        }else if (type == acfun){
            self.vm = [AcFunSearchViewModel new];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.shiBantableView setDoubleAction:@selector(shiBanTableViewDoubleClickRow)];
    [self.episodeTableView setDoubleAction:@selector(episodeTableViewDoubleClickRow)];
}

- (void)refreshWithKeyWord:(NSString *)keyWord completion:(void(^)(NSError *error))completionHandler{
    [self.vm refreshWithKeyWord:keyWord completionHandler:^(NSError *error) {
        _coverImageView.image = [NSImage imageNamed:@"imghold"];
        _titleTextField.stringValue = @"";
        _detailTextField.stringValue = @"";
        [self.shiBantableView reloadData];
        [self.episodeTableView reloadData];
        completionHandler(error);
    }];
}



#pragma mark - 私有方法

- (void)loadInfoView{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL: [self.vm coverImg]];
       dispatch_async(dispatch_get_main_queue(), ^{
           self.coverImageView.image = img;
       });
    });
    
    self.titleTextField.stringValue = [self.vm shiBanTitle];
    self.detailTextField.stringValue = [self.vm shiBanDetail];
}

- (void)shiBanTableViewDoubleClickRow{
    NSInteger row = [self.shiBantableView clickedRow];
    //判断该行是否为新番
    if ([self.vm isShiBanForRow: row]) {
        NSString *seasonID = [self.vm seasonIDForRow: row];
        if (seasonID) {
            [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView: self.episodeTableView];
            [self.vm refreshWithSeasonID:seasonID completionHandler:^(NSError *error) {
                [JHProgressHUD disMiss];
                [self loadInfoView];
                [self.episodeTableView reloadData];
            }];
        }
    }else{
        NSString *aid = [self.vm aidForRow: row];
        if (aid) {
            if ([self.vm isKindOfClass: [BiliBiliSearchViewModel class]]) {
                ThirdPartyDanMuChooseViewController *vc = [[ThirdPartyDanMuChooseViewController alloc] initWithVideoID: aid type: bilibili];
                [self presentViewControllerAsSheet: vc];
            }else if ([self.vm isKindOfClass: [AcFunSearchViewModel class]]){
                ThirdPartyDanMuChooseViewController *vc = [[ThirdPartyDanMuChooseViewController alloc] initWithVideoID: aid type: acfun];
                [self presentViewControllerAsSheet: vc];
            }
        }
    }
}

- (void)episodeTableViewDoubleClickRow{
    if (![self.vm infoArrCount]) return;
    [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView: self.view];
    NSInteger clickRow = [self.episodeTableView clickedRow];
    [self.vm downDanMuWithRow:clickRow completionHandler:^(id responseObj,NSError *error) {
        [JHProgressHUD disMiss];
        
        //通知更新匹配名称
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mathchVideo" object:self userInfo:@{@"animateTitle": [self.vm episodeTitleForRow:clickRow]}];
        //通知关闭列表视图控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:self userInfo:responseObj];
        //通知开始播放
        [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:self userInfo:responseObj];
    }];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([tableView.identifier isEqualToString:@"shiBanTableView"]) {
        return [self.vm shiBanArrCount];
    }else{
        return [self.vm infoArrCount];
    }
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableColumn.identifier isEqualToString:@"shiBanCell"]){
        NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cell.textField.stringValue = [self.vm shiBanTitleForRow: row];
        cell.imageView.image = [self.vm imageForRow: row];
        return cell;
    }else if ([tableColumn.identifier isEqualToString:@"episodeCell"]){
        NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cell.textField.stringValue = [self.vm episodeTitleForRow: row];
        return cell;
    }
    return nil;
}

@end
