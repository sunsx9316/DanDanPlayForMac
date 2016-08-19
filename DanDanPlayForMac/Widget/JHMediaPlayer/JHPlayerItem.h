//
//  JHPlayerItem.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/21.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@class JHPlayerItem;
@protocol JHPlayerItemDelegate <NSObject>
@optional
- (void)JHPlayerItem:(JHPlayerItem *)item bufferStartTime:(NSTimeInterval)bufferStartTime bufferOnceTime:(NSTimeInterval)bufferOnceTime;
@end

@interface JHPlayerItem : AVPlayerItem
@property (weak, nonatomic) id<JHPlayerItemDelegate> delegate;
@end
