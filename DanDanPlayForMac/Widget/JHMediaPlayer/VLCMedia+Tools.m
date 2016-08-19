//
//  VLCMedia+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VLCMedia+Tools.h"

@implementation VLCMedia (Tools)
- (CGSize)videoSize {
    NSArray *mediaInfo = self.tracksInformation;
    
    CGSize size = CGSizeZero;
    //获取视频宽高
    for (NSDictionary *dic in mediaInfo) {
        if (dic[VLCMediaTracksInformationVideoWidth]) {
            size.width = [dic[VLCMediaTracksInformationVideoWidth] floatValue];
        }
        if (dic[VLCMediaTracksInformationVideoHeight]) {
            size.height = [dic[VLCMediaTracksInformationVideoHeight] floatValue];
        }
    }
    return size;
}
@end
