//
//  JHVLCMedia.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHVLCMedia.h"
@interface JHVLCMedia()<VLCMediaDelegate>
@property (nonatomic, strong) complete returnBlock;
@end
@implementation JHVLCMedia
- (void)parseWithBlock:(complete)block{
    self.returnBlock = block;
    self.delegate = self;
    [self synchronousParse];
}

- (void)mediaDidFinishParsing:(VLCMedia *)aMedia{
    self.returnBlock(aMedia);
}


- (instancetype)initWithURL:(NSURL *)anURL{
    if (self = [super initWithURL:anURL]) {
        
    }
    return [super initWithURL:anURL];
}
@end
