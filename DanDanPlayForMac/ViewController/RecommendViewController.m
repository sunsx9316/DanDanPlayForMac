//
//  RecommendViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendItemViewController.h"
#import "NSString+Tools.h"

#import "RecommedViewModel.h"

#import "RecommendHeadCell.h"
#import "RecommendBangumiCell.h"

@interface RecommendViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (strong, nonatomic) RecommedViewModel *vm;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@property (weak) IBOutlet RecommendHeadCell *headView;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSButton *recommendButton;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"番剧推荐";
    [self configHeadView];
    [self.progressHUD showWithView:self.view];
    
    [self.vm refreshWithCompletionHandler:^(NSError *error) {
        [self.progressHUD hideWithCompletion:nil];
        [self.headView setWithModel:self.vm.featuredModel];
        NSArray *arr = self.vm.bangumis;
        
        [arr enumerateObjectsUsingBlock:^(BangumiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:[RecommendItemViewController viewController]];
            item.label = obj.weekDayStringValue;
            [self.tabView addTabViewItem:item];
        }];
    }];
    
    [[UserDefaultManager shareUserDefaultManager] addObserver:self forKeyPath:@"showRecommedInfoAtStart" options:NSKeyValueObservingOptionNew context:nil];
    self.recommendButton.state = [UserDefaultManager shareUserDefaultManager].showRecommedInfoAtStart;
}

- (void)dealloc {
    [[UserDefaultManager shareUserDefaultManager] removeObserver:self forKeyPath:@"showRecommedInfoAtStart"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    self.recommendButton.state = [change[@"new"] integerValue];
}

#pragma mark - NSTableViewDelegate
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem {
    RecommendItemViewController *vc = (RecommendItemViewController *)tabViewItem.viewController;
    vc.model = self.vm.bangumis[[tabView indexOfTabViewItem:tabViewItem]];
}

#pragma mark -  私有方法
- (void)configHeadView {
    [self.headView setClickSearchButtonCallBack:^(NSString *keyWord) {
        if (!keyWord.length) return;
        
        keyWord = [keyWord stringByURLEncode];
        //破软件迟早药丸
        if ([keyWord isEqualToString:@"%E9%95%BF%E8%80%85"] || [keyWord isEqualToString:@"%E8%86%9C%E8%9B%A4"] || [keyWord isEqualToString:@"%E8%9B%A4%E8%9B%A4"] || [keyWord isEqualToString:@"%E8%B5%9B%E8%89%87"]) {
            system("open http://baike.baidu.com/view/1781.htm");
        }
        
        system([NSString stringWithFormat:@"open %@%@", SEARCH_PATH, keyWord].UTF8String);
    }];

    [self.headView setClickFilmReviewButtonCallBack:^(NSString *path) {
        system([NSString stringWithFormat:@"open %@", path].UTF8String);
    }];
    
}

- (IBAction)clickRecommendButton:(NSButton *)sender {
    [UserDefaultManager shareUserDefaultManager].showRecommedInfoAtStart = sender.state;
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
        DanDanPlayMessageModel *model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeLoadMessage];
        _progressHUD = [[JHProgressHUD alloc] init];
        _progressHUD.text = model.message;
//		_progressHUD = [[JHProgressHUD alloc] initWithMessage:model.message style:JHProgressHUDStyleValue1 parentView:self.view dismissWhenClick:NO];
	}
	return _progressHUD;
}

@end
