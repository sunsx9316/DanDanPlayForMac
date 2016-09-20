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
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSearchTextField];
    [self addChildViewController];
}

- (IBAction)searchButtonDown:(NSButton *)sender {
    if (!self.searchTextField.stringValue.length) return;
    
    NSInteger index = [self.tabView indexOfTabViewItem:self.tabView.selectedTabViewItem];
    NSString *keyword = self.searchTextField.stringValue;
    //刷新官方页
    if (index == 0) {
        DanDanSearchViewController *vc = (DanDanSearchViewController *)self.childViewControllers[index];
        vc.keyword = keyword;
    }
    //刷新第三方搜索页
    else {
        ThirdPartySearchViewController *vc = (ThirdPartySearchViewController *)self.childViewControllers[index];
        vc.keyword = keyword;
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
- (void)addViewControllerWithViewController:(NSViewController *)vc title:(NSString *)title {
    NSTabViewItem *tabViewItem = [[NSTabViewItem alloc] init];
    tabViewItem.view = vc.view;
    tabViewItem.label = title;
    [self addChildViewController: vc];
    [self.tabView addTabViewItem: tabViewItem];
}

/**
 *  配置搜索框
 */
- (void)configSearchTextField {
    @weakify(self)
    [self.searchTextField setRespondBlock:^{
        @strongify(self)
        if (!self) return;
        
        [self searchButtonDown:nil];
    }];
    
    self.searchTextField.text = self.searchText;
}

/**
 *  添加子控制器
 */
- (void)addChildViewController {
    DanDanSearchViewController *dvc = [DanDanSearchViewController viewController];
    dvc.keyword = _searchText;
    [self addViewControllerWithViewController:dvc title:@"官方"];
    
    ThirdPartySearchViewController *bvc = [ThirdPartySearchViewController viewControllerWithType:DanDanPlayDanmakuSourceBilibili];
    bvc.keyword = _searchText;
    [self addViewControllerWithViewController:bvc title:@"bilibili"];
    
    ThirdPartySearchViewController *avc = [ThirdPartySearchViewController viewControllerWithType:DanDanPlayDanmakuSourceAcfun];
    avc.keyword = _searchText;
    [self addViewControllerWithViewController:avc title:@"acfun"];
}

@end
