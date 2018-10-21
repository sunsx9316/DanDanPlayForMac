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
@property (strong, nonatomic) IBOutlet NSView *progressView;
@property (weak) IBOutlet NSLayoutConstraint *progressViewWidthConstraint;
@property (strong, nonatomic) NSTrackingArea *trackingArea;
@property (copy, nonatomic) buttonCallBackBlock block;
@end

@implementation VideoNameCell
{
    id<VideoModelProtocol> _model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setWantsLayer:YES];
    self.progressView.backgroundColor = DDPRGBAColor(49, 169, 226, 0.5);
    [self.button setTitleColor:[NSColor whiteColor]];
    [self addTrackingArea:self.trackingArea];
}

- (void)dealloc {
    [self removeTrackingArea:self.trackingArea];
}

- (void)updateProgress:(float)progress {
    self.progressViewWidthConstraint.constant = progress * self.frame.size.width;
}

- (void)setWithModel:(id<VideoModelProtocol>)model iconHide:(BOOL)iconHide callBack:(buttonCallBackBlock)callBack {
    _model = model;
//    NSNumber *value = objc_getAssociatedObject(_model, "progress");
//    if (value) {
//        self.progressViewWidthConstraint.constant = value.floatValue * self.frame.size.width;
//    }
    self.progressViewWidthConstraint.constant = 0;
    self.titleField.text = [model fileName];
    self.iconImageView.hidden = iconHide;
    self.block = callBack;
    self.button.hidden = YES;
}

- (IBAction)clickButton:(NSButton *)sender {
    if (self.block) {
        self.block();
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.button.hidden = YES;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    self.button.hidden = NO;
}

- (NSTrackingArea *)trackingArea {
    if(_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect owner:self userInfo:nil];
    }
    return _trackingArea;
}

@end
