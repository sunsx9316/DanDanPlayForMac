//
//  AboutViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AboutViewController.h"
#import "NSButton+Tools.h"

#import <POP.h>
#import <POP/POPLayerExtras.h>

@interface AboutViewController ()
@property (weak) IBOutlet NSTextField *versionTextField;
@property (weak) IBOutlet NSButton *contactMeButton;
@property (weak) IBOutlet NSTextField *CRTextField;
@property (strong, nonatomic) NSImageView *iconImageView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPreferredContentSize:self.view.bounds.size];
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = RGBColor(51, 51, 51).CGColor;
    [self.contactMeButton setTitleColor:[NSColor whiteColor]];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *copyRight = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSHumanReadableCopyright"];
    
    self.versionTextField.stringValue = version.length ? version : @"";
    self.CRTextField.stringValue = copyRight.length ? copyRight : @"";
    
    
    POPSpringAnimation *springAnimate = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    CGRect frame = self.iconImageView.frame;
    frame.size = CGSizeMake(frame.size.height, frame.size.height);
    frame.origin.x = self.view.center.x - frame.size.width / 2;
    springAnimate.toValue = [NSValue valueWithRect:frame];
    springAnimate.springBounciness = 20.0f;
    [self.iconImageView pop_addAnimation:springAnimate forKey:@"position"];
}


- (IBAction)clickContactMeButton:(NSButton *)sender {
    system([@"open http://weibo.com/u/2996607392" UTF8String]);
}


- (NSImageView *)iconImageView {
	if(_iconImageView == nil) {
		_iconImageView = [[NSImageView alloc] init];
        _iconImageView.imageScaling = NSImageScaleAxesIndependently;
        _iconImageView.image = [NSImage imageNamed:NSImageNameApplicationIcon];
        _iconImageView.frame = CGRectMake(0, 0, 900, 100);
        _iconImageView.center = self.view.center;
        [self.view addSubview:_iconImageView];
	}
	return _iconImageView;
}

@end
