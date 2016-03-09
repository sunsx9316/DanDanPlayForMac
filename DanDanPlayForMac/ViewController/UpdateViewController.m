//
//  UpdateViewController.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/9.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "UpdateViewController.h"
#import "NSButton+Tools.h"
#import "UpdateNetManager.h"

@interface UpdateViewController ()
@property (weak) IBOutlet NSTextField *updateDetailTextField;
@property (weak) IBOutlet NSButton *okButton;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSProgress *progress;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@end

@implementation UpdateViewController
- (instancetype)initWithVersion:(NSString *)version details:(NSString *)details{
    if ((self = kViewControllerWithId(@"UpdateViewController"))) {
        self.version = version?version:@"";
        self.details = details?details:@"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.updateDetailTextField.stringValue = self.details;
    [self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.okButton setTitleColor:[NSColor blueColor]];
    
}
- (IBAction)clickOKButton:(NSButton *)sender {
    [UpdateNetManager downLatestVersionWithVersion:self.version progress:self.progress completionHandler:^(NSString *path, NSError *error) {
        NSLog(@"下载完成: %@", path);
    }];
}
- (IBAction)clickCancelButton:(NSButton *)sender {
    [self dismissViewController:self];
}
- (void)dealloc{
    [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self.progressHUD updateProgress:[change[@"new"] floatValue]];
}

#pragma mark - 懒加载
- (JHProgressHUD *)progressHUD {
	if(_progressHUD == nil) {
		_progressHUD = [[JHProgressHUD alloc] initWithMessage:@"正在下载..." style:JHProgressHUDStyleValue4 parentView:self.view dismissWhenClick:NO];
	}
	return _progressHUD;
}

- (NSProgress *)progress {
	if(_progress == nil) {
		_progress = [NSProgress progressWithTotalUnitCount:1];
	}
	return _progress;
}

@end
