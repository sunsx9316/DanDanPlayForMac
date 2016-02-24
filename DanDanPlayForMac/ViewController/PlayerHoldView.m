//
//  playerHoldView.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/18.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerHoldView.h"
#import "LocalVideoModel.h"
@interface PlayerHoldView()
@property (copy, nonatomic) filePickBlock block;
@end


@implementation PlayerHoldView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setWantsLayer: YES];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSURLPboardType, nil]];
    self.layer.backgroundColor = [NSColor blackColor].CGColor;
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    return NSDragOperationGeneric;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ){
        if (self.block) {
            NSArray *pathArr = [pboard propertyListForType:NSFilenamesPboardType];
            NSMutableArray *localVideosArr = [NSMutableArray array];
            NSFileManager *manager = [NSFileManager defaultManager];
            BOOL isDirectory;
            for (NSString *path in pathArr) {
                if ([manager fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
                    [localVideosArr addObject: [[LocalVideoModel alloc] initWithFilePath:path]];
                }
            }
            self.block(localVideosArr);
        }
    }
    return YES;
}

- (void)setupBlock:(filePickBlock)block{
    self.block = block;
}


@end
