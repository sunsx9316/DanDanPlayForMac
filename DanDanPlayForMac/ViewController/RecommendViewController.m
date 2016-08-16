//
//  RecommendViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendItemViewController.h"

#import "RecommedViewModel.h"

#import "RecommendHeadCell.h"
#import "RecommendBangumiCell.h"

@interface RecommendViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (strong, nonatomic) RecommedViewModel *vm;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@property (weak) IBOutlet RecommendHeadCell *headView;
@property (weak) IBOutlet NSLayoutConstraint *headViewHeightConstraint;
@property (weak) IBOutlet NSTabView *tabView;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressHUD show];
    
    [self.vm refreshWithCompletionHandler:^(NSError *error) {
        [self.progressHUD disMiss];
        self.headViewHeightConstraint.constant = [self.headView heightWithModel:self.vm.featuredModel];
        NSArray *arr = self.vm.bangumis;
        
        [arr enumerateObjectsUsingBlock:^(BangumiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:[[RecommendItemViewController alloc] init]];
            item.label = obj.weekDayStringValue;
            [self.tabView addTabViewItem:item];
        }];
    }];
}

- (instancetype)init {
    if ((self = kViewControllerWithId(@"RecommendViewController"))) {
        self.title = @"番剧推荐";
    }
    return self;
}

#pragma mark - NSTableViewDelegate
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem {
    RecommendItemViewController *vc = (RecommendItemViewController *)tabViewItem.viewController;
    vc.model = self.vm.bangumis[[tabView indexOfTabViewItem:tabViewItem]];
}

#pragma mark - 懒加载
- (RecommedViewModel *)vm {
	if(_vm == nil) {
		_vm = [[RecommedViewModel alloc] init];
	}
	return _vm;
}

- (JHProgressHUD *)progressHUD {
	if(_progressHUD == nil) {
        DanDanPlayMessageModel *model = [UserDefaultManager alertMessageWithType:DanDanPlayMessageTypeLoadMessage];
		_progressHUD = [[JHProgressHUD alloc] initWithMessage:model.message style:JHProgressHUDStyleValue1 parentView:self.view dismissWhenClick:NO];
	}
	return _progressHUD;
}

@end
