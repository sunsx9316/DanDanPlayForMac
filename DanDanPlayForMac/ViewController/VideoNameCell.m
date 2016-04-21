//
//  VideoNameCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/26.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "VideoNameCell.h"
#import "NSButton+Tools.h"

@interface VideoNameCell()
@property (weak, nonatomic) IBOutlet NSTextField *titleField;
@property (weak, nonatomic) IBOutlet NSImageView *iconImageView;
@property (strong, nonatomic) IBOutlet NSButton *button;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@property (copy, nonatomic) buttonCallBackBlock block;
@end

@implementation VideoNameCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setWantsLayer:YES];
    [self.button setTitleColor:[NSColor whiteColor]];
    [self addTrackingArea:self.trackingArea];
}

- (void)dealloc{
    [self removeTrackingArea:self.trackingArea];
}

- (void)setTitle:(NSString *)title iconHide:(BOOL)iconHide callBack:(buttonCallBackBlock)callBack{
    self.titleField.stringValue = title.length ? title : @"";
    self.iconImageView.hidden = iconHide;
    self.block = callBack;
    self.button.hidden = YES;
}

- (IBAction)clickButton:(NSButton *)sender {
    if (self.block) {
        self.block();
    }
}

- (void)mouseExited:(NSEvent *)theEvent{
    self.button.hidden = YES;
}

- (void)mouseEntered:(NSEvent *)theEvent{
    self.button.hidden = NO;
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

@end
