//
//  VLCMedia+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VLCMedia+Tools.h"

@implementation VLCMedia (Tools)
- (CGSize)videoSize{
    NSArray *mediaInfo = self.tracksInformation;
    
    CGFloat width = .0;
    CGFloat height = .0;
    //获取视频宽高
    for (NSDictionary *dic in mediaInfo) {
        if (dic[VLCMediaTracksInformationVideoWidth]) width = [dic[VLCMediaTracksInformationVideoWidth] floatValue];
        if (dic[VLCMediaTracksInformationVideoHeight])  height = [dic[VLCMediaTracksInformationVideoHeight] floatValue];
    }
    return CGSizeMake(width, height);
}
@end
