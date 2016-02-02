//
//  DanDanSearchViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/31.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanDanSearchViewController.h"
#import "DanMuChooseViewController.h"

#import "SearchViewModel.h"
#import "SearchModel.h"

@interface DanDanSearchViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (strong, nonatomic) SearchViewModel *vm;
@end

@implementation DanDanSearchViewController

#pragma mark - 方法
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.outlineView setDoubleAction: @selector(doubleClickRow)];
}

- (void)refreshWithKeyWord:(NSString *)keyWord completion:(void(^)(NSError *error))completionHandler{
    [self.vm refreshWithKeyWord:keyWord completionHandler:^(NSError *error) {
        [self.outlineView reloadData];
        completionHandler(error);
    }];
}

- (void)doubleClickRow{
    id aModel = [self.outlineView itemAtRow: [self.outlineView selectedRow]];
    if ([aModel isKindOfClass: [EpisodesModel class]]) {
        NSString *videoID = [aModel ID];
        if (videoID) {
            DanMuChooseViewController *vc = [[DanMuChooseViewController alloc] initWithVideoID: videoID];
            [self presentViewControllerAsSheet: vc];
        }
    }
}


#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item{
    return [self.vm numberOfChildrenOfItem: item];
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item{
    return [self.vm child:index ofItem:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    return [self.vm ItemExpandable: item];
}

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *result = [outlineView makeViewWithIdentifier:@"cell" owner:self];
    result.textField.stringValue = [self.vm itemContentWithItem: item];
    return result;
}

#pragma mark - 懒加载
- (SearchViewModel *)vm {
	if(_vm == nil) {
		_vm = [[SearchViewModel alloc] init];
	}
	return _vm;
}

@end
