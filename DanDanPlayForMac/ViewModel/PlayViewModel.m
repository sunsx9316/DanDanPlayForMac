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
#import "DanMuModelArr2Dic.h"
@interface PlayViewModel()
/**
 *  保存弹幕模型
 */
@property (nonatomic, strong) NSDictionary <NSNumber *, NSArray *>*dic;
@property (nonatomic, strong) NSString *danMuKu;
@property (nonatomic, strong) NSString *provider;
@end

@implementation PlayViewModel
- (NSArray <DanMuDataModel *>*)currentSecondDanMuArr:(NSInteger)second{
    return self.dic[@(second)];
}

- (instancetype)initWithModel:(id)model provider:(NSString *)provider{
    if (self = [super init]) {
        if ([model isKindOfClass: [DanMuModel class]]) {
            DanMuModel *danMus = (DanMuModel *)model;
            self.dic = [DanMuModelArr2Dic dicWithObj:danMus.comments source: official];
           // NSLog(@"%@", self.dic);
        }else{
            self.danMuKu = model;
            self.provider = provider;
        }
    }
    return self;
}

- (void)getDanMuCompletionHandler:(void(^)(NSError *error))complete{
    //self.danMuKu存在 说明传进来的为danMuKuID 获取弹幕
    if (self.danMuKu && self.provider) {
        // danmuku:弹幕库id provider 提供者
        [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmuku":self.danMuKu, @"provider":self.provider} completionHandler:^(NSDictionary *responseObj, NSError *error) {
            self.dic = responseObj;
           // NSLog(@"%@", self.dic);
            complete(error);
    }];
    }else{
        complete(nil);
    }
}

@end
