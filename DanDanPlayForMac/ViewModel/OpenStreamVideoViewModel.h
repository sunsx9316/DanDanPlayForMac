//
//  OpenStreamVideoViewModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoNetManager.h"
@class StreamingVideoModel;
@interface OpenStreamVideoViewModel : BaseViewModel
- (NSInteger)numOfVideos;
- (NSString *)videoNameForRow:(NSInteger)row;
- (NSString *)danmakuForRow:(NSInteger)row;
- (void)getVideoURLAndDanmakuForRow:(NSInteger)row completionHandler:(void(^)(StreamingVideoModel *videoModel,NSDictionary *danmakuDic, NSError *error))complete;
- (void)refreshWithcompletionHandler:(void(^)(NSError *error))complete;
- (instancetype)initWithAid:(NSString *)aid danmakuSource:(NSString *)danmakuSource;
@end
