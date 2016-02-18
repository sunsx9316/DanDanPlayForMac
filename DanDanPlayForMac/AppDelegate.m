//
//  AppDelegate.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainWindowController = kViewControllerWithId(@"MainWindowController");
    [self.mainWindowController showWindow: self];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)openPreferencePanel:(NSMenuItem *)sender {
    [self.mainWindowController.contentViewController presentViewControllerAsSheet:kViewControllerWithId(@"PreferenceViewController")];
}

- (IBAction)openLocaleFile:(NSMenuItem *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection: YES];
    
    [openPanel beginSheetModalForWindow:self.mainWindowController.window completionHandler:^(NSInteger result) {
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

- (IBAction)clickBackButton:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController ;
    [vc dismissController:vc];
}


#pragma mark - 私有方法
- (void)applicationInitalise{
    //执行一些启动需要的操作
    if ([UserDefaultManager shouldClearCache]) {
        [[NSFileManager defaultManager] removeItemAtPath:[UserDefaultManager cachePath] error:nil];
    }
}

@end
