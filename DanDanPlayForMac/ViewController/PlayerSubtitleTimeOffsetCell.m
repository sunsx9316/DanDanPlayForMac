//
//  PlayerSubtitleTimeOffsetCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/7/21.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSubtitleTimeOffsetCell.h"
#import "NSString+Tools.h"

@interface PlayerSubtitleTimeOffsetCell()
@property (weak) IBOutlet NSTextField *textField;
@end

@implementation PlayerSubtitleTimeOffsetCell
{
    //原来的偏移时间
    NSInteger _originalOffsetTime;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (IBAction)clickInputTextField:(NSTextField *)sender {
    NSString *str = [sender.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isPureInt]) {
        sender.stringValue = str;
        _originalOffsetTime = str.integerValue;
        if (self.timeOffsetCallBack) {
            self.timeOffsetCallBack(_originalOffsetTime);
        }
    }
    else {
        sender.stringValue = [NSString stringWithFormat:@"%ld", _originalOffsetTime];
    }
}

- (IBAction)clickButton:(NSButton *)button{
    if (self.timeOffsetCallBack) {
        NSInteger num = button.tag - 100;
        if (num == 0) {
            _originalOffsetTime = 0;
        }
        else {
            _originalOffsetTime += num;
        }
        self.textField.stringValue = [NSString stringWithFormat:@"%ld", _originalOffsetTime];
        self.timeOffsetCallBack(_originalOffsetTime);
    }
}

@end
