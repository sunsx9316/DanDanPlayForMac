//
//  BackGroundImageView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/1.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BackGroundImageView.h"
@interface BackGroundImageView()
@property (strong, nonatomic) filePickBlock block;
@end

@implementation BackGroundImageView

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSURLPboardType, nil]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    return NSDragOperationGeneric;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ){
        if (self.block) {
            NSArray *pathArr = [pboard propertyListForType:NSFilenamesPboardType];
          //  NSMutableArray *allFiles = [NSMutableArray array];
           // BOOL isDirectory = NO;
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            for (NSString *path in pathArr) {
//                [fileManager fileExistsAtPath: path isDirectory:&isDirectory];
//                if (isDirectory) {
//                    NSArray *contentsArr = [fileManager contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants error:nil];
//                    [allFiles addObjectsFromArray: contentsArr];
//                }else{
//                    [allFiles addObject: path];
//                }
//            }
            self.block(pathArr);
        }
    }
    return YES;
}

- (void)setUpBlock:(filePickBlock)block{
    self.block = block;
}

@end
