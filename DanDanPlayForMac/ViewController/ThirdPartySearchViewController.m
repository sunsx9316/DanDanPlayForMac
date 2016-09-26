//
//  ThirdPartySearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartySearchViewController.h"
#import "ThirdPartyDanmakuChooseViewController.h"
#import "DownLoadOtherDanmakuViewController.h"

#import "ThirdPartySearchVideoInfoView.h"
#import "HUDMessageView.h"

#import "BiliBiliSearchViewModel.h"
#import "AcFunSearchViewModel.h"
#import "LocalVideoModel.h"

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

+ (instancetype)viewControllerWithType:(DanDanPlayDanmakuSource)type {
    ThirdPartySearchViewController *vc = [ThirdPartySearchViewController viewController];
    vc.currentRow = -1;
    if (type == DanDanPlayDanmakuSourceBilibili) {
        vc.vm = [[BiliBiliSearchViewModel alloc] init];
    }
    else if (type == DanDanPlayDanmakuSourceAcfun) {
        vc.vm = [[AcFunSearchViewModel alloc] init];
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    [self.shiBantableView setDoubleAction:@selector(shiBanTableViewDoubleClickRow)];
    [self.episodeTableView setDoubleAction:@selector(episodeTableViewDoubleClickRow)];
    [self refreshByKeyword];
}


- (void)refreshByKeyword {
    [self.hud showWithView:self.view];
    [self.vm refreshWithKeyWord:_keyword completionHandler:^(NSError *error) {
        if (error) {
            [self.messageView showHUD];
        }
        
        //刷新的时候重置视频详情
        self.videoInfoView.coverImg.imageBringPlaceHold = nil;
        self.videoInfoView.animaTitleTextField.text = nil;
        self.videoInfoView.detailTextField.text = nil;
        [self.shiBantableView reloadData];
        [self.episodeTableView reloadData];
        
        [self.hud hideWithCompletion:nil];
    }];
}

#pragma mark - 私有方法
- (void)loadInfoView {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL: [self.vm coverImg]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videoInfoView.coverImg.imageBringPlaceHold = img;
        });
    });
    self.videoInfoView.animaTitleTextField.text = [self.vm shiBanTitle];
    self.videoInfoView.detailTextField.text = [self.vm shiBanDetail];
}

//点击选择节目的行
- (void)shiBanTableViewDoubleClickRow {
    NSInteger row = [self.shiBantableView clickedRow];
    //判断该行是否为新番
    if ([self.vm isShiBanForRow: row] && ![self.shiBanEpisodeHUD isShowing] && self.currentRow != row) {
        self.currentRow = row;
        NSString *seasonID = [self.vm seasonIDForRow: row];
        if (seasonID) {
            [self.shiBanEpisodeHUD showWithView:self.view];
            [self.vm refreshWithSeasonID:seasonID completionHandler:^(NSError *error) {
                [self.shiBanEpisodeHUD hideWithCompletion:nil];
                [self loadInfoView];
                [self.episodeTableView reloadData];
            }];
        }
    }
    else {
        NSString *aid = [self.vm aidForRow: row];
        if (aid) {
            if ([self.vm isKindOfClass: [BiliBiliSearchViewModel class]]) {
                ThirdPartyDanmakuChooseViewController *vc = [ThirdPartyDanmakuChooseViewController viewControllerWithVideoId: aid type: DanDanPlayDanmakuSourceBilibili];
                [self presentViewControllerAsSheet: vc];
            }
            else if ([self.vm isKindOfClass: [AcFunSearchViewModel class]]) {
                ThirdPartyDanmakuChooseViewController *vc = [ThirdPartyDanmakuChooseViewController viewControllerWithVideoId: aid type: DanDanPlayDanmakuSourceAcfun];
                [self presentViewControllerAsSheet: vc];
            }
        }
    }
}

//双击击番剧对应分集的行
- (void)episodeTableViewDoubleClickRow {
    if (![self.vm infoArrCount]) return;
    
    [[JHProgressHUD shareProgressHUD] showWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message parentView: self.view];
    NSInteger clickRow = [self.episodeTableView clickedRow];
    [self.vm downDanMuWithRow:clickRow completionHandler:^(NSDictionary *danmakuDic, NSError *error) {
        [[JHProgressHUD shareProgressHUD] hideWithCompletion:nil];
        
        if (error) {
            [self.messageView showHUD];
            return;
        }
        
        id<VideoModelProtocol>vm = [ToolsManager shareToolsManager].currentVideoModel;
        if (vm) {
            vm.matchTitle = [self.vm episodeTitleForRow:clickRow];
            vm.danmakuDic = danmakuDic;
            //通知开始播放
            [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAY" object:@[vm]];
        }
    }];
}

#pragma mark getter setter
- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    if (self.isViewLoaded) {
        [self refreshByKeyword];
    }
}

//点击缓存其它弹幕按钮
- (IBAction)clickDownloadOtherDanmakuButton:(NSButton *)sender {
    NSArray *arr = [self.vm videoInfoDataModels];
    if (arr.count) {
        DanDanPlayDanmakuSource danmakuSource = [self.vm isKindOfClass:[BiliBiliSearchViewModel class]] ? DanDanPlayDanmakuSourceBilibili : DanDanPlayDanmakuSourceAcfun;
        DownLoadOtherDanmakuViewController *vc = [DownLoadOtherDanmakuViewController viewController];
        vc.videos = arr;
        vc.source = danmakuSource;
        [self presentViewControllerAsModalWindow:vc];
    }
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([tableView.identifier isEqualToString:@"shiBanTableView"]) {
        return self.vm.shiBanArrCount;
    }
    else {
        return self.vm.infoArrCount;
    }
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableColumn.identifier isEqualToString:@"shiBanCell"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cell.textField.text = [self.vm shiBanTitleForRow: row];
        cell.imageView.image = [self.vm imageForRow: row];
        return cell;
    }
    else if ([tableColumn.identifier isEqualToString:@"episodeCell"]){
        NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cell.textField.text = [self.vm episodeTitleForRow: row];
        return cell;
    }
    return nil;
}


#pragma mark - 懒加载
- (JHProgressHUD *)hud {
    if(_hud == nil) {
        _hud = [[JHProgressHUD alloc] init];
        _hud.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message;
        _shiBanEpisodeHUD.hideWhenClick = NO;
    }
    return _hud;
}

- (JHProgressHUD *)shiBanEpisodeHUD {
    if(_shiBanEpisodeHUD == nil) {
        _shiBanEpisodeHUD = [[JHProgressHUD alloc] init];
        _shiBanEpisodeHUD.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage].message;
        _shiBanEpisodeHUD.hideWhenClick = NO;
    }
    return _shiBanEpisodeHUD;
}

- (HUDMessageView *)messageView {
    if(_messageView == nil) {
        _messageView = [[HUDMessageView alloc] init];
        _messageView.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeConnectFail].message;
    }
    return _messageView;
}

@end
