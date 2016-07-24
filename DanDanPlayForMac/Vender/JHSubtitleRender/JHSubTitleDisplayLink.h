//
//  JHDisplayLink.h
//  CocoaUtils
//
//  Created by Nick Hutchinson on 01/05/2013.
//
//

#import <CoreVideo/CoreVideo.h>
#import <Foundation/Foundation.h>
@class JHSubTitleDisplayLink;

@protocol JHSubTitleDisplayLinkDelegate <NSObject>
- (void)displayLink:(JHSubTitleDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp;
@end


@interface JHSubTitleDisplayLink : NSObject

@property (nonatomic, weak) id <JHSubTitleDisplayLinkDelegate> delegate;

@property (nonatomic) dispatch_queue_t dispatchQueue;

- (void)start;
- (void)stop;

@end


