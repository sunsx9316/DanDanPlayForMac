//
//  HUDMessageView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "HUDMessageView.h"
@interface HUDMessageView()
@property (strong, nonatomic) NSImageView *imgView;
@property (strong, nonatomic) NSTextField *textField;
@end
@implementation HUDMessageView
- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self addSubview:self.imgView];
        [self addSubview:self.textField];
        _imgView.frame = self.bounds;
        _textField.frame = CGRectMake((self.bounds.size.width - _textField.frame.size.width) / 2, (self.bounds.size.height + 6 - _textField.frame.size.height) / 2, _textField.bounds.size.width, _textField.bounds.size.height);
    }
    return self;
}

- (void)updateMessage:(NSString *)message{
    _textField.stringValue = message;
}

- (void)show{
    self.animator.alphaValue = 1;
}

- (void)hide{
    self.animator.alphaValue = 0;
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    if (_reverse) {
        _imgView.image = [NSImage imageNamed:@"hud_message_frame_right"];
    }else {
        _imgView.image = [NSImage imageNamed:@"hud_message_frame_left"];
    }
}

#pragma mark - 懒加载
- (NSImageView *)imgView {
	if(_imgView == nil) {
		_imgView = [[NSImageView alloc] init];
        _imgView.image = [NSImage imageNamed:@"hud_message_frame_left"];
        [_imgView.image setCapInsets:NSEdgeInsetsMake(10, 10, 10, 10)];
	}
	return _imgView;
}

- (NSTextField *)textField {
	if(_textField == nil) {
		_textField = [[NSTextField alloc] init];
        _textField.stringValue = @"00:00";
        [_textField setTextColor:[NSColor whiteColor]];
        _textField.editable = NO;
        _textField.bordered = NO;
        _textField.drawsBackground = NO;
        [_textField sizeToFit];
	}
	return _textField;
}

@end
