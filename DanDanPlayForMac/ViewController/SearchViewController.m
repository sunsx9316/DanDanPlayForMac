//
//  SearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/31.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "SearchViewController.h"
#import "DanDanSearchViewController.h"
#import "JHProgressHUD.h"

@interface SearchViewController ()<NSTabViewDelegate>
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSSearchField *searchTextField;
@property (strong, nonatomic) NSMutableArray <NSViewController *>*viewController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView:self.view];
    self.searchTextField.stringValue = self.searchText;
    
    DanDanSearchViewController *dvc = (DanDanSearchViewController *)[self addViewControllerWithTitile:@"官方" ID:@"DanDanSearchViewController"];
    [dvc refreshWithKeyWord: self.searchText completion:^(NSError *error) {
        [JHProgressHUD disMiss];
    }];
    
}

- (instancetype)init{
    return (self = kViewControllerWithId(@"SearchViewController"));
}

- (IBAction)searchButtonDown:(NSButton *)sender {
    NSInteger index = [self.tabView indexOfTabViewItem:self.tabView.selectedTabViewItem];
    if (index == 0) {
        DanDanSearchViewController *dvc = (DanDanSearchViewController *)self.viewController[index];
        if (!dvc) return;
        
        [JHProgressHUD showWithMessage:@"你不能让我加载, 我就加载" parentView:self.view];
        [dvc refreshWithKeyWord: self.searchTextField.stringValue completion:^(NSError *error) {
            [JHProgressHUD disMiss];
        }];
    }
}

- (IBAction)backButtonDown:(NSButton *)sender {
    [self dismissController: self];
}


#pragma mark - 私有方法
/**
 *  向tabview添加控制器
 *
 *  @param title 控制器标题
 *  @param ID    控制器storyboardid
 *
 *  @return 控制器
 */
- (NSViewController *)addViewControllerWithTitile:(NSString *)title ID:(NSString *)ID{
    NSTabViewItem *tabViewItem = [[NSTabViewItem alloc] init];
    NSViewController *vc = kViewControllerWithId(ID);
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
