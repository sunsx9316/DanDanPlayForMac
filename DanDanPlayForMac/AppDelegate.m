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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainWindowController = kViewControllerWithId(@"MainWindowController");
    [self.mainWindowController showWindow: self];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    NSButton *closeButton = [self.mainWindowController.window standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeApplication)];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - 私有方法
- (IBAction)openPreferencePanel:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    [vc presentViewControllerAsSheet:kViewControllerWithId(@"PreferenceViewController")];
}

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

- (IBAction)clickBackButton:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    [vc dismissController:vc];
}

- (IBAction)clickNetButton:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    [vc presentViewControllerAsSheet:[[OpenStreamInputAidViewController alloc] init]];
}
- (IBAction)clickAboutButton:(NSMenuItem *)sender {
    NSViewController *vc = [NSApplication sharedApplication].keyWindow.contentViewController;
    [vc presentViewControllerAsModalWindow:kViewControllerWithId(@"AboutViewController")];
}

- (IBAction)clickEverydayRecommendButton:(NSMenuItem *)sender {
    [[NSApp mainWindow].contentViewController presentViewControllerAsModalWindow:[[RecommendViewController alloc] init]];
}

- (void)closeApplication {
    [[NSApplication sharedApplication] terminate:nil];
}

//- (void)firstRun{
//    
//    [[NSFileManager defaultManager] removeItemAtPath:[UserDefaultManager cachePath] error:nil];
//}
@end
