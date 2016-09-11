//
//  JHVLCMedia.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHVLCMedia.h"
#import "VLCMedia+Tools.h"

@interface JHVLCMedia()<VLCMediaDelegate>
@property (nonatomic, copy) parseCompleteBlock returnBlock;
@end

@implementation JHVLCMedia
- (void)parseWithBlock:(parseCompleteBlock)block {
    self.returnBlock = block;
//    self.delegate = self;
    [self parseWithOptions:VLCMediaParseLocal | VLCMediaParseNetwork | VLCMediaFetchLocal | VLCMediaFetchNetwork];
    [self addObserver:self forKeyPath:@"parsedStatus" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"parsedStatus"]) {
        if (self.returnBlock) {
            self.returnBlock(self.videoSize);
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"parsedStatus"];
}

- (instancetype)initWithURL:(NSURL *)anURL {
    return (self = [super initWithURL:anURL]);
}

- (instancetype)initWithPath:(NSString *)aPath {
    return [self initWithURL: [NSURL fileURLWithPath: aPath]];
}
@end
