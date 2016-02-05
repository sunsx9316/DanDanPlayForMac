//
//  PlayViewModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "PlayViewModel.h"
#import "DanMuModel.h"
#import "DanMuNetManager.h"
#import "LocalVideoModel.h"
@interface PlayViewModel()
/**
 *  保存弹幕模型
 */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSArray *>*dic;
@property (nonatomic, strong) NSString *danMuKu;
@property (nonatomic, strong) NSString *provider;
@property (strong, nonatomic) LocalVideoModel *video;
@end

@implementation PlayViewModel
- (NSArray <DanMuDataModel *>*)currentSecondDanMuArr:(NSInteger)second{
    NSArray *arr = self.dic[@(second)];
    self.dic[@(second)] = nil;
    return arr;
}

- (NSURL *)videoURL{
    return [NSURL fileURLWithPath: self.video.filePath];
}

- (NSString *)videoName{
    return self.video.fileName;
}

- (instancetype)initWithLocalVideoModel:(LocalVideoModel *)localVideoModel danMuDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.video = localVideoModel;
        self.dic = [dic mutableCopy];
    }
    return self;
}

@end
