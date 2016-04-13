//
//  NSOpenPanel+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSOpenPanel (Tools)
+ (instancetype)chooseDirectoriesPanelWithTitle:(NSString *)title defaultURL:(NSURL *)url;
+ (instancetype)chooseFilePanelWithTitle:(NSString *)title defaultURL:(NSURL *)url;
+ (instancetype)chooseFileAndDirectoriesPanelWithTitle:(NSString *)title defaultURL:(NSURL *)url allowsMultipleSelection:(BOOL)allowsMultipleSelection;
@end
