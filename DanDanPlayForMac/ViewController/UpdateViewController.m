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
#import "NSData+Tools.h"
#import "NSAlert+Tools.h"

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
        self.version = version.length?version:@"";
        self.details = details.length?details:@"";
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
//    NSProgress *_progress;
    
    [UpdateNetManager downLatestVersionWithVersion:self.version progress:^(NSProgress *downloadProgress) {
        [self.progressHUD updateProgress:downloadProgress.fractionCompleted];
    } completionHandler:^(id responseObj, NSError *error) {
        [self.progressHUD disMiss];
        if (!responseObj) {
            DanDanPlayMessageModel *model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDownloadFile];
            [[NSAlert alertWithMessageText:model.message informativeText:model.infomationMessage] runModal];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *fileData = [[NSData alloc] initWithContentsOfFile:responseObj];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[fileData md5String] isEqualToString:self.fileHash]) {
                    system([[NSString stringWithFormat:@"open %@", responseObj] cStringUsingEncoding:NSUTF8StringEncoding]);
                }
                else {
                    DanDanPlayMessageModel *model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloadFileDamage];
                    NSAlert *alert = [NSAlert alertWithMessageText:model.message informativeText:model.infomationMessage];
                    [alert runModal];
                }
//                [_progress removeObserver:self forKeyPath:@"fractionCompleted"];
                [self dismissViewController:self];
            });
        });
    }];
    
//    [UpdateNetManager downLatestVersionWithVersion:self.version progress:&_progress completionHandler:^(NSString *responseObj, NSError *error) {
//        [self.progressHUD disMiss];
//        if (!responseObj) {
//            [[NSAlert alertWithMessageText:[UserDefaultManager alertMessageWithKey:@"kNoFoundDownLoadFileString"] informativeText:[UserDefaultManager alertMessageWithKey:@"kNoFoundDownLoadFileInformativeString"]] runModal];
//            return;
//        }
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSData *fileData = [[NSData alloc] initWithContentsOfFile:responseObj];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([[fileData md5String] isEqualToString:self.fileHash]) {
//                    system([[NSString stringWithFormat:@"open %@", responseObj] cStringUsingEncoding:NSUTF8StringEncoding]);
//                }
//                else {
//                    NSAlert *alert = [NSAlert alertWithMessageText:[UserDefaultManager alertMessageWithKey:@"kDownLoadFileDamageString"] informativeText:[UserDefaultManager alertMessageWithKey:@"kDownLoadFileDamageInformativeString"]];
//                    [alert runModal];
//                }
//                [_progress removeObserver:self forKeyPath:@"fractionCompleted"];
//                [self dismissViewController:self];
//            });
//        });
//        
//    }];
//    [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
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

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.progressHUD updateProgress:[change[@"new"] floatValue]];
//    });
//}

#pragma mark - 懒加载
- (JHProgressHUD *)progressHUD {
    if(_progressHUD == nil) {
        _progressHUD = [[JHProgressHUD alloc] initWithMessage:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloading].message style:JHProgressHUDStyleValue4 parentView:self.view indicatorSize:CGSizeMake(200, 30) fontSize:[NSFont systemFontSize] dismissWhenClick:NO];
    }
    return _progressHUD;
}

@end
