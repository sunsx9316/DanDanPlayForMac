//
//  playerHoldView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerHoldView.h"
#import "LocalVideoModel.h"
@implementation PlayerHoldView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setWantsLayer: YES];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSURLPboardType, nil]];
    self.layer.backgroundColor = [NSColor blackColor].CGColor;
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationGeneric;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ){
        if (self.filePickBlock) {
            NSArray *pathArr = [pboard propertyListForType:NSFilenamesPboardType];
            NSMutableArray *localVideosArr = [NSMutableArray array];
            for (NSString *path in pathArr) {
                NSArray *arr = [self contentsOfDirectoryAtURL:path];
                if (arr.count) {
                    [localVideosArr addObjectsFromArray:arr];
                }
            }
            self.filePickBlock(localVideosArr);
        }
    }
    return YES;
}

- (NSArray *)contentsOfDirectoryAtURL:(NSString *)path{
    BOOL isDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path isDirectory:&isDirectory]) {
        if (!isDirectory) return @[[[LocalVideoModel alloc] initWithFilePath:path]];
    }
    NSMutableArray *arr = [[fileManager contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants error:nil] mutableCopy];
    
    //移除一级目录下的文件夹
    for (NSInteger i = arr.count - 1; i >= 0; --i) {
        NSURL *url = arr[i];
        if ([fileManager fileExistsAtPath: url.path isDirectory:&isDirectory]) {
            if (isDirectory) [arr removeObjectAtIndex: i];
            else arr[i] = [[LocalVideoModel alloc] initWithFileURL:url];
        }
    }
    return arr;
}
@end
