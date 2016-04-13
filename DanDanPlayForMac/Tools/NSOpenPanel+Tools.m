//
//  NSOpenPanel+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSOpenPanel+Tools.h"

@implementation NSOpenPanel (Tools)
+ (instancetype)chooseDirectoriesPanelWithTitle:(NSString *)title defaultURL:(NSURL *)url {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:url];
    [openPanel setTitle:title];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection: NO];
    return openPanel;
}

+ (instancetype)chooseFilePanelWithTitle:(NSString *)title defaultURL:(NSURL *)url {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:title];
    [openPanel setCanChooseDirectories: NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection: NO];
    return openPanel;
}

+ (instancetype)chooseFileAndDirectoriesPanelWithTitle:(NSString *)title defaultURL:(NSURL *)url allowsMultipleSelection:(BOOL)allowsMultipleSelection{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:url];
    [openPanel setTitle:title];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection: YES];
    return openPanel;
}
@end
