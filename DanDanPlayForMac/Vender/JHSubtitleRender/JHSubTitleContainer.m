
//
//  DanmakuContainer.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHSubTitleContainer.h"

@implementation JHSubTitleContainer
{
    JHSubtitle *_subTitle;
    NSDictionary *_globalAttributedDic;
}
- (instancetype)initWithSubTitle:(JHSubtitle *)subTitle {
    if (self = [super init]) {
#if !TARGET_OS_IPHONE
        self.editable = NO;
        self.drawsBackground = NO;
        self.bordered = NO;
#endif
        [self setWithSubTitle:subTitle];
    }
    return self;
}

- (void)setWithSubTitle:(JHSubtitle *)subTitle {
    _subTitle = subTitle;
    self.JHAttributedText = subTitle.attributedString;
    [self sizeToFit];
}

- (BOOL)updatePositionWithTime:(NSTimeInterval)time {
    return [_subTitle updatePositonWithTime:time container:self];
}

- (JHSubtitle *)subTitle {
    return _subTitle;
}

- (void)setOriginalPosition:(CGPoint)originalPosition {
    _originalPosition = originalPosition;
    CGRect rect = self.frame;
    rect.origin = originalPosition;
    self.frame = rect;
}

- (void)setGlobalAttributedDic:(NSDictionary *)globalAttributedDic {
    if (!self.JHAttributedText.length || !globalAttributedDic) return;
    _globalAttributedDic = globalAttributedDic;
    self.JHAttributedText = [[NSMutableAttributedString alloc] initWithString:self.JHAttributedText.string attributes:globalAttributedDic];
    [self sizeToFit];
}

- (NSDictionary *)globalAttributedDic {
    if (_globalAttributedDic) {
        return _globalAttributedDic;
    }
    return self.JHAttributedText.length ? [self.JHAttributedText attributesAtIndex:0 effectiveRange:nil] : nil;
}

#pragma mark - 私有方法
- (NSShadow *)shadowWithTextColor:(JHColor *)textColor {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, -1);
    shadow.shadowColor = [self shadowColorWithTextColor:textColor];
    return shadow;
}

- (JHColor *)shadowColorWithTextColor:(JHColor *)textColor {
    if (JHColorBrightness(textColor) > 0.5) {
        return [JHColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return [JHColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
