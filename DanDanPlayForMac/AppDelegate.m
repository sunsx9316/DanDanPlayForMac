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

@implementation AppDelegate
{
    //右键打开的文件
    NSArray<NSString *> *_filePaths;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    NSButton *closeButton = [self.mainWindowController.window standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeApplication)];
    
    self.mainWindowController = kViewControllerWithId(@"MainWindowController");
    [self.mainWindowController showWindow: self];
    
    MainViewController *vc = (MainViewController *)self.mainWindowController.contentViewController;
    [vc setUpWithFilePath:_filePaths];
    [self firstRun];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
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
 *  第一次启动操作
 */
- (void)firstRun {
 //   if ([UserDefaultManager shareUserDefaultManager].firstRun) {
        [UserDefaultManager shareUserDefaultManager].videoListOrderedSet = nil;
        [UserDefaultManager shareUserDefaultManager].firstRun = NO;
  //  }
}

@end
