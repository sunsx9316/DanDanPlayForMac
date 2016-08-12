//
//  SearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/31.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "SearchViewController.h"
#import "DanDanSearchViewController.h"
#import "ThirdPartySearchViewController.h"
#import "RespondKeyboardSearchField.h"
#import "BiliBiliSearchViewModel.h"
#import "AcFunSearchViewModel.h"

@interface SearchViewController ()<NSTabViewDelegate>
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet RespondKeyboardSearchField *searchTextField;
@property (strong, nonatomic) NSMutableArray <NSViewController *>*viewController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonDown:) name:@"DISSMISS_VIEW_CONTROLLER" object: nil];
    
    @weakify(self)
    [self.searchTextField setRespondBlock:^{
        @strongify(self)
        if (!self) return;
        
        [self searchButtonDown:nil];
    }];
    
    self.searchTextField.stringValue = self.searchText;
    DanDanSearchViewController *dvc = (DanDanSearchViewController *)[self addViewControllerWithViewController:kViewControllerWithId(@"DanDanSearchViewController") title:@"官方"];
    [dvc refreshWithKeyWord: self.searchText completion: nil];
    
    ThirdPartySearchViewController *bvc = (ThirdPartySearchViewController *)[self addViewControllerWithViewController:[[ThirdPartySearchViewController alloc] initWithType:JHDanMuSourceBilibili] title:@"bilibili"];
    [bvc refreshWithKeyWord:self.searchText completion:^(NSError *error) {
        [JHProgressHUD disMiss];
    }];
    
    ThirdPartySearchViewController *avc = (ThirdPartySearchViewController *)[self addViewControllerWithViewController:[[ThirdPartySearchViewController alloc] initWithType:JHDanMuSourceAcfun] title:@"acfun"];
    [avc refreshWithKeyWord:self.searchText completion:^(NSError *error) {
        [JHProgressHUD disMiss];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)init {
    return (self = kViewControllerWithId(@"SearchViewController"));
}

- (IBAction)searchButtonDown:(NSButton *)sender {
    if (!self.searchTextField.stringValue.length) return;
    
    NSInteger index = [self.tabView indexOfTabViewItem:self.tabView.selectedTabViewItem];
    //刷新官方页
    if (index == 0) {
        DanDanSearchViewController *dvc = (DanDanSearchViewController *)self.viewController[index];
        if (!dvc) return;
        
        [dvc refreshWithKeyWord: self.searchTextField.stringValue completion: nil];
    //刷新第三方搜索页
    }
    else{
        ThirdPartySearchViewController *dvc = (ThirdPartySearchViewController *)self.viewController[index];
        if (!dvc) return;
        
        [dvc refreshWithKeyWord: self.searchTextField.stringValue completion: nil];
    }
}

- (IBAction)backButtonDown:(NSButton *)sender {
    [self dismissController: self];
}



#pragma mark - 私有方法
/**
 *  向tabview添加控制器
 *
 *  @param vc    控制器
 *  @param title 控制器名称
 *
 *  @return 控制器
 */
- (NSViewController *)addViewControllerWithViewController:(NSViewController *)vc title:(NSString *)title {
    NSTabViewItem *tabViewItem = [[NSTabViewItem alloc] init];
    tabViewItem.view = vc.view;
    tabViewItem.label = title;
    [self addChildViewController: vc];
    [self.viewController addObject: vc];
    [self.tabView addTabViewItem: tabViewItem];
    return vc;
}

#pragma mark - 懒加载

- (NSMutableArray <NSViewController *> *)viewController {
	if(_viewController == nil) {
		_viewController = [[NSMutableArray <NSViewController *> alloc] init];
	}
	return _viewController;
}

@end
