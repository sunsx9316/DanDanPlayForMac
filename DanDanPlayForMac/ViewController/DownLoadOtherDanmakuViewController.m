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
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSMutableSet *downloadDanmakus;
@end

@implementation DownLoadOtherDanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithVideos:(NSArray <VideoInfoDataModel *>*)videos danMuSource:(NSString *)danMuSource{
    if (!danMuSource) return nil;
    if ((self = kViewControllerWithId(@"DownLoadOtherDanmakuViewController"))) {
        self.videos = videos;
        self.source = danMuSource;
    }
    return self;
}

- (IBAction)clickSelectAllButton:(NSButton *)sender {
    if (sender.state) {
        for (NSInteger i = 0; i < self.videos.count; ++i) {
            [self.downloadDanmakus addObject:@(i)];
        }
    }else{
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
    NSMutableArray *taskArr = [NSMutableArray array];
    NSArray *allDownLoadDanmaku = self.downloadDanmakus.allObjects;
    for (NSInteger i = 0; i < allDownLoadDanmaku.count; ++i) {
        NSInteger index = [allDownLoadDanmaku[i] integerValue];
        NSString *danmakuID = self.videos[index].danmaku;
        if (!danmakuID) continue;
        
        [taskArr addObject:[DanMuNetManager downThirdPartyDanMuWithParameters:@{@"provider":self.source, @"danmaku":danmakuID} completionHandler:^(id responseObj, NSError *error) {
            if ([responseObj count] > 0) {
                [self writeDanMuCacheWithProvider:self.source danmakuID:danmakuID responseObj:responseObj];
            }
        }]];
    }
    
    NSArray* operations = [AFURLConnectionOperation batchOfRequestOperations:taskArr progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
       // NSLog(@"%ld %ld",numberOfFinishedOperations,totalNumberOfOperations);
    }completionBlock:^(NSArray *operations) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadOver" object:nil userInfo:@{@"downloadCount":[NSString stringWithFormat:@"%ld", operations.count]}];
    }];
    [[NSOperationQueue mainQueue] addOperations:@[operations.lastObject] waitUntilFinished:NO];
    [self dismissController:self];
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
- (void)writeDanMuCacheWithProvider:(NSString *)provider danmakuID:(NSString *)danmakuID responseObj:(id)responseObj{
    //将弹幕写入缓存
    NSString *cachePath = [[UserDefaultManager cachePath] stringByAppendingPathComponent:provider];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [NSKeyedArchiver archiveRootObject:responseObj toFile:[cachePath stringByAppendingPathComponent:danmakuID]];
    }]];
    
}

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
