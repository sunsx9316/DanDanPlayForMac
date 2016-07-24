//
//  JHSubtitle.m
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubtitle.h"
#import "JHSubTitleContainer.h"

@implementation JHSubtitle
- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(JHSubTitleContainer *)container {
    return _disappearTime >= time;
}

- (NSTimeInterval)during {
    return _disappearTime - _appearTime;
}

- (CGPoint)originalPositonWithContainerArr:(NSArray <JHSubTitleContainer *>*)arr contentRect:(CGRect)rect subTitleSize:(CGSize)subTitleSize {
    NSMutableDictionary <NSNumber *, NSMutableArray <JHSubTitleContainer *>*>*dic = [NSMutableDictionary dictionary];
    NSInteger channelCount = [self channelCountWithContentRect:rect subTitleSize:subTitleSize];
    //轨道高
    NSInteger channelHeight = rect.size.height / channelCount;
    
    for (int i = 0; i < arr.count; ++i) {
        JHSubTitleContainer *obj = arr[i];
        //判断字幕所在轨道
        NSInteger channel = obj.frame.origin.y / channelHeight;
        
        if (!dic[@(channel)]) dic[@(channel)] = [NSMutableArray array];
        
        [dic[@(channel)] addObject:obj];
    }
    
    __block NSInteger channel = channelCount - 1;
    //每条轨道都有弹幕
    if (dic.count == channelCount) {
        __block NSInteger minCount = dic[@(0)].count;
        [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<JHSubTitleContainer *> * _Nonnull obj, BOOL * _Nonnull stop) {
            if (minCount >= obj.count) {
                minCount = obj.count;
                channel = key.intValue;
            }
        }];
    }
#if TARGET_OS_IPHONE
    else {
        for (NSInteger i = channelCount - 1; i >= 0; --i) {
            if (!dic[@(i)]) {
                channel = i;
                break;
            }
        }
    }
#elif TARGET_OS_MAC
    else {
        for (NSInteger i = 0; i < channelCount; ++i) {
            if (!dic[@(i)]) {
                channel = i;
                break;
            }
        }
    }
    
#endif
    return CGPointMake((rect.size.width - subTitleSize.width) / 2, channelHeight * channel + 20);
}


#pragma mark - 私有方法
- (CGPoint)originalPositionWithBounds:(CGRect)bounds subTitleSize:(CGSize)subTitleSize {
    return CGPointMake((bounds.size.width - subTitleSize.width) / 2, 10);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%lf, %lf, %@", _appearTime, _disappearTime, _attributedString.string];
}

- (NSInteger)channelCountWithContentRect:(CGRect)contentRect subTitleSize:(CGSize)subTitleSize {
    NSInteger channelCount = contentRect.size.height / subTitleSize.height;
    return channelCount > 4 ? channelCount : 4;
}

@end
