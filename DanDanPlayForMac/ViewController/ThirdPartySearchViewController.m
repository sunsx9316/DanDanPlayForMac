//
//  ThirdPartySearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartySearchViewController.h"
#import "ThirdPartyDanMuChooseViewController.h"
#import "DownLoadOtherDanmakuViewController.h"
#import "ThirdPartySearchVideoInfoView.h"
#import "BiliBiliSearchViewModel.h"
#import "AcFunSearchViewModel.h"
#import "HUDMessageView.h"

@interface ThirdPartySearchViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet ThirdPartySearchVideoInfoView *videoInfoView;
@property (strong, nonatomic) ThirdPartySearchViewModel *vm;
@property (strong, nonatomic) JHProgressHUD *hud;
@property (strong, nonatomic) HUDMessageView *messageView;
@property (strong, nonatomic) JHProgressHUD *shiBanEpisodeHUD;
//记录当前点击的行
@property (assign, nonatomic) NSInteger currentRow;
@end

@implementation ThirdPartySearchViewController

- (instancetype)initWithType:(JHDanMuSource)type{
    if ((self = kViewControllerWithId(@"ThirdPartySearchViewController"))) {
        self.currentRow = -1;
        if (type == JHDanMuSourceBilibili) {
            self.vm = [BiliBiliSearchViewModel new];
        }else if (type == JHDanMuSourceAcfun){
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
    //展示状态直接返回
    if (self.hud.isShowing) return;
    
    [self.hud show];
    [self.vm refreshWithKeyWord:keyWord completionHandler:^(NSError *error) {
        
        if (error) {
            [self.messageView showHUD];
        }
        
        //刷新的时候重置视频详情
        self.videoInfoView.coverImg.image = [NSImage imageNamed:@"img_hold"];
        self.videoInfoView.animaTitleTextField.stringValue = @"";
        self.videoInfoView.detailTextField.stringValue = @"";
        [self.shiBantableView reloadData];
        [self.episodeTableView reloadData];
        
        [self.hud disMiss];
        if (completionHandler) completionHandler(error);
    }];
}

#pragma mark - 私有方法
- (void)loadInfoView{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL: [self.vm coverImg]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videoInfoView.coverImg.image = img;
        });
    });
    self.videoInfoView.animaTitleTextField.stringValue = [self.vm shiBanTitle];
    self.videoInfoView.detailTextField.stringValue = [self.vm shiBanDetail];
}

- (void)shiBanTableViewDoubleClickRow {
    NSInteger row = [self.shiBantableView clickedRow];
    //判断该行是否为新番
    if ([self.vm isShiBanForRow: row] && ![self.shiBanEpisodeHUD isShowing] && self.currentRow != row) {
        self.currentRow = row;
        NSString *seasonID = [self.vm seasonIDForRow: row];
        if (seasonID) {
            [self.shiBanEpisodeHUD show];
            [self.vm refreshWithSeasonID:seasonID completionHandler:^(NSError *error) {
                [self.shiBanEpisodeHUD disMiss];
                [self loadInfoView];
                [self.episodeTableView reloadData];
            }];
        }
    }
    else {
        NSString *aid = [self.vm aidForRow: row];
        if (aid) {
            if ([self.vm isKindOfClass: [BiliBiliSearchViewModel class]]) {
                ThirdPartyDanMuChooseViewController *vc = [[ThirdPartyDanMuChooseViewController alloc] initWithVideoID: aid type: JHDanMuSourceBilibili];
                [self presentViewControllerAsSheet: vc];
            }
            else if ([self.vm isKindOfClass: [AcFunSearchViewModel class]]) {
                ThirdPartyDanMuChooseViewController *vc = [[ThirdPartyDanMuChooseViewController alloc] initWithVideoID: aid type: JHDanMuSourceAcfun];
                [self presentViewControllerAsSheet: vc];
            }
        }
    }
}

- (void)episodeTableViewDoubleClickRow {
    if (![self.vm infoArrCount]) return;
    
    [JHProgressHUD showWithMessage:[UserDefaultManager alertMessageWithKey:@"kLoadMessageString"] parentView: self.view];
    NSInteger clickRow = [self.episodeTableView clickedRow];
    [self.vm downDanMuWithRow:clickRow completionHandler:^(id responseObj, NSError *error) {
        [JHProgressHUD disMiss];
        
        if (error) {
            [self.messageView showHUD];
            return;
        }
        
        //通知更新匹配名称
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MATCH_VIDEO" object:self userInfo:@{@"animateTitle": [self.vm episodeTitleForRow:clickRow]}];
        //通知关闭列表视图控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISSMISS_VIEW_CONTROLLER" object:self userInfo:nil];
        //通知开始播放
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DANMAKU_CHOOSE_OVER" object:self userInfo:responseObj];
    }];
}

- (IBAction)clickDownloadOtherDanmakuButton:(NSButton *)sender {
    NSArray *arr = [self.vm videoInfoDataModels];
    if (arr.count) {
        NSString *danMuSource = [self.vm isKindOfClass:[BiliBiliSearchViewModel class]]?@"bilibili":@"acfun";
        [self presentViewControllerAsModalWindow:[[DownLoadOtherDanmakuViewController alloc] initWithVideos:arr danMuSource:danMuSource]];
    }
}


#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([tableView.identifier isEqualToString:@"shiBanTableView"]) {
        return [self.vm shiBanArrCount];
    }
    else {
        return [self.vm infoArrCount];
    }
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableColumn.identifier isEqualToString:@"shiBanCell"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cell.textField.stringValue = [self.vm shiBanTitleForRow: row];
        cell.imageView.image = [self.vm imageForRow: row];
        return cell;
    }
    else if ([tableColumn.identifier isEqualToString:@"episodeCell"]){
        NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cell.textField.stringValue = [self.vm episodeTitleForRow: row];
        return cell;
    }
    return nil;
}


#pragma mark - 懒加载
- (JHProgressHUD *)hud {
    if(_hud == nil) {
        _hud = [[JHProgressHUD alloc] initWithMessage:[UserDefaultManager alertMessageWithKey:@"kLoadMessageString"] style:JHProgressHUDStyleValue1 parentView:self.view indicatorSize:CGSizeMake(30, 30) fontSize:[NSFont systemFontSize] dismissWhenClick:NO];
    }
    return _hud;
}

- (JHProgressHUD *)shiBanEpisodeHUD {
	if(_shiBanEpisodeHUD == nil) {
		_shiBanEpisodeHUD = [[JHProgressHUD alloc] initWithMessage:[UserDefaultManager alertMessageWithKey:@"kLoadMessageString"] style:JHProgressHUDStyleValue1 parentView:self.episodeTableView dismissWhenClick:NO];
	}
	return _shiBanEpisodeHUD;
}

- (HUDMessageView *)messageView {
    if(_messageView == nil) {
        _messageView = [[HUDMessageView alloc] init];
        _messageView.text.stringValue = [UserDefaultManager alertMessageWithKey:@"kConnectFailString"];
//        [self.view addSubview: _messageView positioned:NSWindowAbove relativeTo:self.episodeTableView];
    }
    return _messageView;
}

@end
