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
#import "VersionModel.h"

@interface UpdateViewController ()
@property (weak) IBOutlet NSTextField *updateDetailTextField;
@property (weak) IBOutlet NSButton *autoUpdateButton;
@property (weak) IBOutlet NSButton *downloadButton;

//@property (strong, nonatomic) NSString *version;
//@property (strong, nonatomic) NSString *details;
//@property (strong, nonatomic) NSString *fileHash;
@property (strong, nonatomic) VersionModel *model;
@property (strong, nonatomic) JHProgressHUD *progressHUD;
@property (weak) IBOutlet NSButton *autoCheakUpdateInfoButton;

@end

@implementation UpdateViewController

+ (instancetype)viewControllerWithModel:(VersionModel *)model {
    UpdateViewController *vc = [UpdateViewController viewController];
    vc.model = model;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.updateDetailTextField.text = _model.details;
    [self.autoUpdateButton setTitleColor:MAIN_COLOR];
    [self.downloadButton setTitleColor:[NSColor darkGrayColor]];
    
    self.autoCheakUpdateInfoButton.state = [UserDefaultManager shareUserDefaultManager].cheakDownLoadInfoAtStart;
}

- (IBAction)clickOKButton:(NSButton *)sender {
    [self.progressHUD showWithView:self.view];
    
    [UpdateNetManager downLatestVersionWithVersion:[NSString stringWithFormat:@"%@", _model.version] progress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressHUD.progress = downloadProgress.fractionCompleted;
        });
    } completionHandler:^(NSURL *filePath, NSError *error) {
        [self.progressHUD hideWithCompletion:nil];
        //下载文件不存在
        if (!filePath.path.length) {
            DanDanPlayMessageModel *model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoFoundDownloadFile];
            [[NSAlert alertWithMessageText:model.message informativeText:model.infomationMessage] runModal];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *fileData = [[NSData alloc] initWithContentsOfURL:filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[fileData md5String] isEqualToString:_model.md5]) {
                    system([[NSString stringWithFormat:@"open %@", filePath] cStringUsingEncoding:NSUTF8StringEncoding]);
                }
                else {
                    DanDanPlayMessageModel *model = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloadFileDamage];
                    NSAlert *alert = [NSAlert alertWithMessageText:model.message informativeText:model.infomationMessage];
                    [alert runModal];
                }
                [self.presentingViewController dismissViewController:self];
            });
        });
    }];
}


- (IBAction)clickUpdateByUserButton:(NSButton *)sender {
    system("open http://www.dandanplay.com/");
}

- (IBAction)clickAutoCheakUpdateInfoButton:(NSButton *)sender {
    [UserDefaultManager shareUserDefaultManager].cheakDownLoadInfoAtStart = sender.state;
}

#pragma mark - 懒加载
- (JHProgressHUD *)progressHUD {
    if(_progressHUD == nil) {
        _progressHUD = [[JHProgressHUD alloc] init];
        _progressHUD.text = [DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeDownloading].message;
        _progressHUD.style = JHProgressHUDStyleValue4;
        _progressHUD.indicatorSize = CGSizeMake(200, 30);
        _progressHUD.hideWhenClick = NO;
    }
    return _progressHUD;
}

@end
