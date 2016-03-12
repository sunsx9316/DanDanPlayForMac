//
//  JHDisplayLink.h
//  CocoaUtils
//
//  Created by Nick Hutchinson on 01/05/2013.
//
//

#import <CoreVideo/CoreVideo.h>
#import <Foundation/Foundation.h>

@protocol JHDisplayLinkDelegate;

@interface JHDisplayLink : NSObject

@property (nonatomic, weak) id <JHDisplayLinkDelegate> delegate;

@property (nonatomic) dispatch_queue_t dispatchQueue;

- (void)start;
- (void)stop;

@end


@protocol JHDisplayLinkDelegate <NSObject>
- (void)displayLink:(JHDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp;
@end