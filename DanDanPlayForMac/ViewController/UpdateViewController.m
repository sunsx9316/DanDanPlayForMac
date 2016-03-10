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
@property (strong, nonatomic) NSString *fileHash;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@property (weak) IBOutlet NSButton *autoCheakUpdateInfoButton;

@end

@implementation UpdateViewController
- (instancetype)initWithVersion:(NSString *)version details:(NSString *)details hash:(NSString *)hash{
    if ((self = kViewControllerWithId(@"UpdateViewController"))) {
        self.version = version?version:@"";
        self.details = details?details:@"";
        self.fileHash = hash;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.updateDetailTextField.stringValue = self.details;
    [self.okButton setTitleColor:[NSColor blueColor]];
    self.autoCheakUpdateInfoButton.state = [UserDefaultManager cheakDownLoadInfoAtStart];
    
}

- (IBAction)clickOKButton:(NSButton *)sender {
    [self.progressHUD show];
    NSProgress *_progress;
    [UpdateNetManager downLatestVersionWithVersion:self.version progress:&_progress completionHandler:^(NSString *responseObj, NSError *error) {
        [self.progressHUD disMiss];
        if (!responseObj) {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"并没有找到下载的文件";
            alert.informativeText = @"→_→可能是下载路径有误 可以尝试手动更新";
            [alert runModal];
            return;
        }
        
        system([[NSString stringWithFormat:@"open %@", responseObj] cStringUsingEncoding:NSUTF8StringEncoding]);
        [_progress removeObserver:self forKeyPath:@"fractionCompleted"];
        [self dismissViewController:self];
    }];
    [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
}
- (IBAction)clickCancelButton:(NSButton *)sender {
    [self dismissViewController:self];
}

- (IBAction)clickUpdateByUserButton:(NSButton *)sender {
    system("open http://pan.baidu.com/s/1kUnnfGr");
}
- (IBAction)clickAutoCheakUpdateInfoButton:(NSButton *)sender {
    [UserDefaultManager setCheakDownLoadInfoAtStart:sender.state];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressHUD updateProgress:[change[@"new"] floatValue]];
    });
}

#pragma mark - 懒加载
- (JHProgressHUD *)progressHUD {
	if(_progressHUD == nil) {
		_progressHUD = [[JHProgressHUD alloc] initWithMessage:@"下载中..." style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:CGSizeMake(200, 30) fontSize:[NSFont systemFontSize] dismissWhenClick:NO];
	}
	return _progressHUD;
}

@end
