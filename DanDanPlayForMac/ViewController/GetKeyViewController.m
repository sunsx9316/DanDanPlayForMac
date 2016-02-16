//
//  GetKeyViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "GetKeyViewController.h"
#import "NSString+KeyEvent.h"

@interface GetKeyViewController ()
@property (strong, nonatomic) getKeyInfoBlock block;
@property (weak) IBOutlet NSTextField *functionTextField;
@property (weak) IBOutlet NSTextField *keyNameTextField;
//记录大小写锁定键 打开时 flag要减去65536
@property (assign, nonatomic, getter=isCapsLockOn) BOOL capsLockOn;
@end

@implementation GetKeyViewController
{
    NSString *_functionName;
    NSString *_keyName;
    NSInteger _flag;
    NSInteger _keyCode;
}
- (instancetype)initWithFunctionName:(NSString *)functionName keyName:(NSString *)keyName getBlock:(getKeyInfoBlock)getBlock{
    if (self = [super initWithNibName:@"GetKeyViewController" bundle:nil]) {
        _keyName = keyName?keyName:@"";
        _functionName = functionName?functionName:@"";
        self.block = getBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.functionTextField.stringValue = [NSString stringWithFormat:@"\"%@\"", _functionName];
    self.keyNameTextField.stringValue = _keyName;
}
- (IBAction)clickOKButton:(NSButton *)sender {
    if (self.block) {
        self.block(self.keyNameTextField.stringValue, _keyCode, _flag);
        [self clickCancelButton: nil];
    }
}
- (IBAction)clickCancelButton:(NSButton *)sender {
    [self dismissController: self];
}

#pragma mark - 私有方法

- (void)flagsChanged:(NSEvent *)event{
    if ([event keyCode] == 0x39){
        NSUInteger flags = [event modifierFlags];
        if (flags & NSAlphaShiftKeyMask) self.capsLockOn = YES;
        else self.capsLockOn = NO;
    }
}

- (void)keyDown:(NSEvent *)theEvent{
    NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 17; i <= 20; ++i) {
        int temp = flags >> i & 1;
        if (temp) {
            switch (i) {
                case 17:
                    [str appendString:@"⇧ "];
                    break;
                case 18:
                    [str appendString:@"⌃ "];
                    break;
                case 19:
                    [str appendString:@"⌥ "];
                    break;
                case 20:
                    [str appendString:@"⌘ "];
                    break;
                default:
                    break;
            }
        }
    }
    [str appendString:[NSString stringWithKeyEventCharactersIgnoringModifiers:theEvent]];
    self.keyNameTextField.stringValue = str;
    _flag = flags - self.capsLockOn * NSAlphaShiftKeyMask;
    _keyCode = theEvent.keyCode;
}

@end
