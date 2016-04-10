//
//  AboutViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AboutViewController.h"
#import "NSButton+Tools.h"

@interface AboutViewController ()
@property (weak) IBOutlet NSTextField *versionTextField;
@property (weak) IBOutlet NSButton *contactMeButton;
@property (weak) IBOutlet NSTextField *CRTextField;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPreferredContentSize:self.view.bounds.size];
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = [NSColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1].CGColor;
    [self.contactMeButton setTitleColor:[NSColor whiteColor]];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *copyRight = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSHumanReadableCopyright"];
    
    self.versionTextField.stringValue = version.length ? version : @"";
    self.CRTextField.stringValue = copyRight.length ? copyRight : @"";
}
- (IBAction)clickContactMeButton:(NSButton *)sender {
    system([@"open http://weibo.com/u/2996607392" UTF8String]);
}

@end
