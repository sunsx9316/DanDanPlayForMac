//
//  DanmakuContainer.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanmakuContainer.h"

@implementation DanmakuContainer
{
    ParentDanmaku *_danmaku;
}
- (instancetype)initWithDanmaku:(ParentDanmaku *)danmaku{
    if (self = [super init]) {
#if !TARGET_OS_IPHONE
        self.editable = NO;
        self.drawsBackground = NO;
        self.bordered = NO;
#endif
        [self setWithDanmaku:danmaku];
    }
    return self;
}

- (void)setWithDanmaku:(ParentDanmaku *)danmaku{
    _danmaku = danmaku;
    self.textColor = danmaku.textColor;
    self.JHText = danmaku.text?danmaku.text:@"";
    self.JHAttributedText = danmaku.attributedString;
    [self sizeToFit];
}

- (BOOL)updatePositionWithTime:(NSTimeInterval)time{
    return [_danmaku updatePositonWithTime:time container:self];
}

- (ParentDanmaku *)danmaku{
    return _danmaku;
}

- (void)setOriginalPosition:(CGPoint)originalPosition{
    _originalPosition = originalPosition;
    CGRect rect = self.frame;
    rect.origin = originalPosition;
    self.frame = rect;
}

- (void)setGlobalAttributedDic:(NSDictionary *)globalAttributedDic{
    if (globalAttributedDic) {
        _globalAttributedDic = globalAttributedDic;
        self.JHAttributedText = [[NSMutableAttributedString alloc] initWithString:self.JHAttributedText.string attributes:globalAttributedDic];
        [self sizeToFit];
    }
}

- (void)setGlobalFont:(JHFont *)globalFont{
    if (globalFont) {
        _globalFont = globalFont;
        NSMutableDictionary *dic = [[self.JHAttributedText attributesAtIndex:0 effectiveRange:nil] mutableCopy];
        dic[NSFontAttributeName] = globalFont;
        [self setGlobalAttributedDic:dic];
    }
}

@end
