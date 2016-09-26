//
//  DownLoadOtherDanmakuViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DownLoadOtherDanmakuViewController.h"
#import "VideoInfoModel.h"
#import "DanmakuNetManager.h"
#import "NOResponseButton.h"
#import "NSTableView+Tools.h"

@interface DownLoadOtherDanmakuViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *selectedAllButton;
@property (strong, nonatomic) NSMutableSet *downloadDanmakus;
@end

@implementation DownLoadOtherDanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.selectedAllButton.state = self.downloadDanmakus.count == self.videos.count;
    [self.tableView reloadData];
}

- (IBAction)clickReverSelectButton:(NSButton *)sender {
    for (NSInteger i = 0; i < self.videos.count; ++i) {
        [self.downloadDanmakus containsObject:@(i)]?[self.downloadDanmakus removeObject:@(i)]:[self.downloadDanmakus addObject:@(i)];
    }
    [self.tableView reloadData];
}

- (IBAction)clickRow:(NSTableView *)sender {
    NSInteger selectRow = [sender selectedRow];
    if (selectRow < self.videos.count) {
        if ([self.downloadDanmakus containsObject:@(selectRow)]) {
            [self.downloadDanmakus removeObject:@(selectRow)];
        }
        else {
            [self.downloadDanmakus addObject:@(selectRow)];
        }
    }
    self.selectedAllButton.state = self.downloadDanmakus.count == self.videos.count;
    [self.tableView reloadRow:selectRow inColumn:0];

}


- (IBAction)clickOKButton:(NSButton *)sender {
    //需要请求弹幕详情的任务
    NSMutableArray *aidArr = [NSMutableArray array];
    NSMutableArray *danmakuArr = [NSMutableArray array];
    NSArray *allDownLoadDanmaku = self.downloadDanmakus.allObjects;
    for (NSInteger i = 0; i < allDownLoadDanmaku.count; ++i) {
        @autoreleasepool {
            NSInteger index = [allDownLoadDanmaku[i] integerValue];
            VideoInfoDataModel *model = self.videos[index];
            NSString *danmakuID = model.danmaku;
            NSString *aid = model.aid;
            if (!danmakuID.length && aid.length) {
                [aidArr addObject:aid];
            }
            else {
                [danmakuArr addObject:danmakuID];
            }
        }
    }
    
    [DanmakuNetManager batchGETDanmakuInfoWithAids:aidArr source:_source completionHandler:^(NSArray *responseObjs, NSArray<NSURLSessionTask *> *tasks) {
        [danmakuArr addObjectsFromArray:responseObjs];
        [DanmakuNetManager batchDownDanmakuWithDanmakuIds:danmakuArr source:_source progressBlock:nil completionHandler:^(NSArray *responseObjs, NSArray<NSURLSessionTask *> *tasks) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_OVER" object:[NSString stringWithFormat:@"下载完成 一共%ld个", responseObjs.count]];
        }];
    }];
}


#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NOResponseButton *button = [tableView makeViewWithIdentifier:@"downOtherDanmakuCheakButton" owner:self];
    button.title = self.videos[row].title;
    button.state = [self.downloadDanmakus containsObject:@(row)];
    button.tag = row;
    return button;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.videos.count;
}

#pragma mark - 懒加载
- (NSMutableSet *)downloadDanmakus {
	if(_downloadDanmakus == nil) {
		_downloadDanmakus = [[NSMutableSet alloc] init];
	}
	return _downloadDanmakus;
}

@end
