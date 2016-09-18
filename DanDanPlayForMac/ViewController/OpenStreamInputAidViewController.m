//
//  OpenStreamInputAidViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "OpenStreamInputAidViewController.h"
#import "OpenStreamVideoViewController.h"
#import "RespondKeyboardTextField.h"

@interface OpenStreamInputAidViewController ()
@property (weak) IBOutlet RespondKeyboardTextField *inputTextField;
@property (weak) IBOutlet NSPopUpButton *danmakuSourcePopUpButton;

@end

@implementation OpenStreamInputAidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [self.inputTextField setRespondBlock:^{
        @strongify(self)
        if (!self) return;
        
        [self clickOKButton:nil];
    }];
}

- (IBAction)clickOKButton:(NSButton *)sender {
    NSString *inputText = self.inputTextField.stringValue;
    if (!inputText.length) return;
    
    DanDanPlayDanmakuSource source = [ToolsManager enumValueWithDanmakuSourceStringValue:[self.danmakuSourcePopUpButton titleOfSelectedItem]];
    
    [self presentViewControllerAsSheet:[OpenStreamVideoViewController viewControllerWithURL:inputText danmakuSource:source]];
}

- (IBAction)dismiss:(NSButton *)sender {
    [self dismissController:self];
}

@end
