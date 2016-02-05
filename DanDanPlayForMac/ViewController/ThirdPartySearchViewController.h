//
//  ThirdPartySearchViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ThirdPartySearchViewController : NSViewController
@property (weak) IBOutlet NSTableView *shiBantableView;
@property (weak) IBOutlet NSTableView *episodeTableView;
- (void)refreshWithKeyWord:(NSString *)keyWord completion:(void(^)(NSError *error))completionHandler;
@end
