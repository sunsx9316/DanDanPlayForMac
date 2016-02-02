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

- (IBAction)openLocaleFile:(NSMenuItem *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    
    [openPanel beginSheetModalForWindow:self.mainWindowController.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            MainViewController *vc = (MainViewController *)[self.mainWindowController contentViewController];
            [vc setUpWithFilePath: [[openPanel URL] path]];
        }
    }];
}

@end
