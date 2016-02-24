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
        self.editable = NO;
        self.drawsBackground = NO;
        self.bordered = NO;
        [self setWithDanmaku:danmaku];
    }
    return self;
}

- (void)setWithDanmaku:(ParentDanmaku *)danmaku{
    _danmaku = danmaku;
    self.stringValue = danmaku.text?danmaku.text:@"";
    self.textColor = danmaku.textColor;
    //self.font = danmaku.font;
    self.attributedStringValue = danmaku.attributedString;
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
        self.attributedStringValue = [[NSMutableAttributedString alloc] initWithString:self.attributedStringValue.string attributes:globalAttributedDic];
        [self sizeToFit];
    }
}

- (void)setGlobalFont:(NSFont *)globalFont{
    if (globalFont) {
        _globalFont = globalFont;
        NSMutableDictionary *dic = [[self.attributedStringValue attributesAtIndex:0 effectiveRange:nil] mutableCopy];
        dic[NSFontAttributeName] = globalFont;
        [self setGlobalAttributedDic:dic];
    }
}

@end
