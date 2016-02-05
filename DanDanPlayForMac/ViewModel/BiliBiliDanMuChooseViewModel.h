//
//  BiliBiliDanMuChooseViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"

@interface BiliBiliDanMuChooseViewModel : BaseViewModel
- (NSInteger)episodeCount;
- (NSString *)episodeTitleWithIndex:(NSInteger)index;
- (NSString *)danMuKuWithIndex:(NSInteger)index;
- (void)refreshCompletionHandler:(void(^)(NSError *error))complete;
- (void)downThirdPartyDanMuWithIndex:(NSInteger)index completionHandler:(void(^)(id responseObj))complete;
- (instancetype)initWithAid:(NSString *)aid;
@end
