//
//  DownLoadOtherDanmakuViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DownLoadOtherDanmakuViewController.h"
#import "VideoInfoModel.h"
#import "DanMuNetManager.h"

@interface DownLoadOtherDanmakuViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) NSArray <VideoInfoDataModel *>*videos;
@property (assign, nonatomic) DanDanPlayDanmakuSource source;
@property (strong, nonatomic) NSMutableSet *downloadDanmakus;
@end

@implementation DownLoadOtherDanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithVideos:(NSArray <VideoInfoDataModel *>*)videos danMuSource:(DanDanPlayDanmakuSource)danMuSource {
    if ((self = kViewControllerWithId(@"DownLoadOtherDanmakuViewController"))) {
        _videos = videos;
        _source = danMuSource;
    }
    return self;
}

- (IBAction)clickSelectAllButton:(NSButton *)sender {
    if (sender.state) {
        for (NSInteger i = 0; i < self.videos.count; ++i) {
            [self.downloadDanmakus addObject:@(i)];
        }
    }
    else {
        [self.downloadDanmakus removeAllObjects];
    }
    [self.tableView reloadData];
}

- (IBAction)clickReverSelectButton:(NSButton *)sender {
    for (NSInteger i = 0; i < self.videos.count; ++i) {
        [self.downloadDanmakus containsObject:@(i)]?[self.downloadDanmakus removeObject:@(i)]:[self.downloadDanmakus addObject:@(i)];
    }
    [self.tableView reloadData];
}


- (IBAction)clickOKButton:(NSButton *)sender {
#warning TODO
    //需要请求弹幕详情的任务
    NSMutableArray *requestAidTaskArr = [NSMutableArray array];
    NSMutableArray *requestDanmakuTaskArr = [NSMutableArray array];
    NSArray *allDownLoadDanmaku = self.downloadDanmakus.allObjects;
    for (NSInteger i = 0; i < allDownLoadDanmaku.count; ++i) {
        @autoreleasepool {
            NSInteger index = [allDownLoadDanmaku[i] integerValue];
            VideoInfoDataModel *model = self.videos[index];
            NSString *danmakuID = model.danmaku;
            NSString *aid = model.aid;
            if (!danmakuID.length && aid.length) {
                [requestAidTaskArr addObject:aid];
            }
            else {
                [requestDanmakuTaskArr addObject:danmakuID];
            }
        }
        
//        id task = [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"provider":self.source, @"danmaku":danmakuID} completionHandler:^(id responseObj, NSError *error) {}];
//        if (task) [taskArr addObject:task];
    }
    
    [DanMuNetManager batchGETDanmakuInfoWithAids:requestAidTaskArr source:_source completionHandler:^(NSArray *responseObjs, NSArray<NSURLSessionTask *> *tasks) {
        [requestDanmakuTaskArr addObjectsFromArray:responseObjs];
        
        [DanMuNetManager batchDownDanmakuWithDanmakuIds:requestDanmakuTaskArr source:_source progressBlock:nil completionHandler:^(NSArray *responseObjs, NSArray<NSURLSessionTask *> *tasks) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_OVER" object:nil userInfo:@{@"downloadCount":[NSString stringWithFormat:@"%ld", responseObjs.count]}];
        }];
    }];
//
//    NSArray* operations = [AFURLConnectionOperation batchOfRequestOperations:taskArr progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//       // NSLog(@"%ld %ld",numberOfFinishedOperations,totalNumberOfOperations);
//    }completionBlock:^(NSArray *operations) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_OVER" object:nil userInfo:@{@"downloadCount":[NSString stringWithFormat:@"%ld", operations.count]}];
//    }];
//    [[NSOperationQueue mainQueue] addOperations:@[operations.lastObject] waitUntilFinished:NO];
//    [self dismissController:self];
}


#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSButton *button = [tableView makeViewWithIdentifier:@"downOtherDanmakuCheakButton" owner:self];
    button.title = self.videos[row].title;
    button.state = [self.downloadDanmakus containsObject:@(row)];
    button.tag = row;
    [button setTarget:self];
    [button setAction:@selector(buttonDown:)];
    return button;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.videos.count;
}

#pragma mark - 私有方法

- (void)buttonDown:(NSButton *)button{
    if ([self.downloadDanmakus containsObject:@(button.tag)]) {
        [self.downloadDanmakus removeObject:@(button.tag)];
    }else{
        [self.downloadDanmakus addObject:@(button.tag)];
    }
}

#pragma mark - 懒加载
- (NSMutableSet *)downloadDanmakus {
	if(_downloadDanmakus == nil) {
		_downloadDanmakus = [[NSMutableSet alloc] init];
	}
	return _downloadDanmakus;
}

@end
