//
//  JHDisplayLink.h
//  CocoaUtils
//
//  Created by Nick Hutchinson on 01/05/2013.
//
//

#import <Cocoa/Cocoa.h>

@protocol JHDisplayLinkDelegate;

@interface JHDisplayLink : NSObject

@property (nonatomic, weak) id <JHDisplayLinkDelegate> delegate;

/// The queue on which delegate callbacks will be delivered; defaults to the
/// main queue
@property (nonatomic) dispatch_queue_t dispatchQueue;

- (void)start;
- (void)stop;

@end


@protocol JHDisplayLinkDelegate <NSObject>
- (void)displayLink:(JHDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp;
@end