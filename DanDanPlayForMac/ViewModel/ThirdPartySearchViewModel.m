//
//  ThirdPartySearchViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/6.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ThirdPartySearchViewModel.h"

@implementation ThirdPartySearchViewModel
- (NSInteger)shiBanArrCount{
    return 0;
}
- (NSInteger)infoArrCount{
    return 0;
}
- (NSString *)shiBanTitleForRow:(NSInteger)row{
    return nil;
}
- (NSString *)episodeTitleForRow:(NSInteger)row{
    return nil;
}
- (NSString *)seasonIDForRow:(NSInteger)row{
    return nil;
}
- (NSURL *)coverImg{
    return nil;
}
- (NSString *)shiBanTitle{
    return nil;
}
- (NSString *)shiBanDetail{
    return nil;
}
- (BOOL)isShiBanForRow:(NSInteger)row{
    return NO;
}
- (NSImage *)imageForRow:(NSInteger)row{
    return nil;
}
- (NSString *)aidForRow:(NSInteger)row{
    return nil;
}
- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete{
    
}
- (void)refreshWithSeasonID:(NSString*)SeasonID completionHandler:(void(^)(NSError *error))complete{
    
}
- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(NSError *error))complete{
    
}
@end
