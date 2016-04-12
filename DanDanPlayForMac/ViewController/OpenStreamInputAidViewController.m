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
    __weak typeof(self)weakSelf = self;
    [self.inputTextField setRespondBlock:^{
        [weakSelf clickOKButton:nil];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMissSelf:) name:@"DISSMISS_VIEW_CONTROLLER" object: nil];
}

- (IBAction)clickOKButton:(NSButton *)sender {
    NSString *inputText = self.inputTextField.stringValue;
    if (!inputText || [inputText isEqualToString:@""]) return;
    [self presentViewControllerAsSheet:[[OpenStreamVideoViewController alloc] initWithAid:inputText danmakuSource:[self.danmakuSourcePopUpButton titleOfSelectedItem]]];
}

- (IBAction)disMissSelf:(NSButton *)sender{
    [self dismissController:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)init{
    return (self = kViewControllerWithId(@"OpenStreamInputAidViewController"));
}

@end
