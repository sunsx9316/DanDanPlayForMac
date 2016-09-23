//
//  AppDelegate.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "OpenStreamInputAidViewController.h"
#import "RecommendViewController.h"
#import "AboutViewController.h"
#import "NSOpenPanel+Tools.h"
#import "PreferenceViewController.h"

#import "UpdateNetManager.h"
#import <JPEngine.h>

@implementation AppDelegate
{
    //右键打开的文件
    NSArray<NSString *> *_filePaths;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self patchAPP];
    [self firstRun];
    self.mainWindowController = kViewControllerWithId(@"MainWindowController");
    [self.mainWindowController showWindow: self];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    NSButton *closeButton = [self.mainWindowController.window standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeApplication)];
    
    MainViewController *vc = (MainViewController *)self.mainWindowController.contentViewController;
    [vc setUpWithFilePath:_filePaths];
}

//即将关闭操作
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    dispatch_group_t group = dispatch_group_create();
    
    for (NSURLSessionDownloadTask *obj in [ToolsManager shareToolsManager].downLoadTaskSet) {
        NSString *md5 = objc_getAssociatedObject(obj, "md5");
        NSString *path = [[UserDefaultManager shareUserDefaultManager].downloadResumeDataPath stringByAppendingPathComponent:md5];
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            [obj cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                [resumeData writeToFile:path atomically:YES];
                dispatch_group_leave(group);
            }];
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames {
    _filePaths = filenames;
    MainViewController *vc = (MainViewController *)self.mainWindowController.contentViewController;
    [vc setUpWithFilePath:_filePaths];
}

#pragma mark - 私有方法
/**
 *  点击偏好设置
 *
 *  @param sender 菜单
 */
- (IBAction)openPreferencePanel:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    if ([vc isKindOfClass:[PreferenceViewController class]]) return;
    [vc presentViewControllerAsSheet:[PreferenceViewController viewController]];
}

#pragma mark - 私有方法
/**
 *  打开本地文件
 *
 *  @param sender 菜单
 */
- (IBAction)openLocaleFile:(NSMenuItem *)sender {
    NSWindow *window = [NSApplication sharedApplication].keyWindow;
    
    if (window != self.mainWindowController.window || [self.mainWindowController.window.contentViewController childViewControllers].count) return;
    
    NSOpenPanel* openPanel = [NSOpenPanel chooseFileAndDirectoriesPanelWithTitle:@"选择文件/文件夹" defaultURL:nil allowsMultipleSelection:YES];
    
    [openPanel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            MainViewController *vc = (MainViewController *)[self.mainWindowController contentViewController];
            NSMutableArray *pathArr = [NSMutableArray array];
            NSArray *urlArr = [openPanel URLs];
            [urlArr enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [pathArr addObject: obj.path];
            }];
            [vc setUpWithFilePath: pathArr];
        }
    }];
}

/**
 *  点击返回按钮
 *
 *  @param sender 菜单
 */
- (IBAction)clickBackButton:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    [vc dismissController:vc];
}

/**
 *  点击网络播放按钮
 *
 *  @param sender 菜单
 */
- (IBAction)clickNetButton:(NSMenuItem *)sender {
    OpenStreamInputAidViewController *openVC = [OpenStreamInputAidViewController viewController];
    [self.mainWindowController.contentViewController presentViewControllerAsSheet:openVC];
}

/**
 *  点击关于按钮
 *
 *  @param sender 菜单
 */
- (IBAction)clickAboutButton:(NSMenuItem *)sender {
    [self.mainWindowController.contentViewController presentViewControllerAsModalWindow:[AboutViewController viewController]];
}

/**
 *  点击每天推荐按钮
 *
 *  @param sender 菜单
 */
- (IBAction)clickEverydayRecommendButton:(NSMenuItem *)sender {
    [self.mainWindowController.contentViewController presentViewControllerAsModalWindow:[RecommendViewController viewController]];
}

/**
 *  关闭操作
 */
- (void)closeApplication {
    [[NSApplication sharedApplication] terminate:nil];
}

/**
 *  打补丁
 */
- (void)patchAPP {
    UserDefaultManager *manager = [UserDefaultManager shareUserDefaultManager];
    NSString *patchPath = [manager.patchPath stringByAppendingPathComponent:manager.versionModel.patchName];
    NSString *script = [NSString stringWithContentsOfFile:patchPath encoding:NSUTF8StringEncoding error:nil];
    if (([script rangeOfString:@"<html>"].location == NSNotFound)) {
        [JPEngine startEngine];
        [JPEngine evaluateScript:script];
    }
}



/**
 *  第一次启动操作
 */
- (void)firstRun {
    //记录的版本比当前版本小
    if ([UserDefaultManager shareUserDefaultManager].versionModel.version < [ToolsManager appVersion]) {
        NSMutableArray *customKeyMapArr = [UserDefaultManager shareUserDefaultManager].customKeyMapArr;
        NSMutableArray *keyMapArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_key_map" ofType:@"plist"]];
        //添加关闭弹幕快捷键
        if (customKeyMapArr.count < keyMapArr.count) {
            [customKeyMapArr addObject:keyMapArr.lastObject];
        }
        [UserDefaultManager shareUserDefaultManager].customKeyMapArr = customKeyMapArr;
        [UserDefaultManager shareUserDefaultManager].videoListOrderedSet = nil;
        //清空上一次的版本信息
        VersionModel *model = [[VersionModel alloc] init];
        model.version = [ToolsManager appVersion];
        [UserDefaultManager shareUserDefaultManager].versionModel = model;
    }
}

@end
