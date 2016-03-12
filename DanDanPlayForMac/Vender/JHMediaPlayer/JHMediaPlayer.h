//
//  JHMediaPlayer.h
//  test
//
//  Created by JimHuang on 16/3/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "JHMediaView.h"

typedef NS_ENUM(NSUInteger, JHMediaPlayerStatus) {
    JHMediaPlayerStatusPlaying,
    JHMediaPlayerStatusPause,
    JHMediaPlayerStatusStop
};
typedef NS_ENUM(NSUInteger, JHMediaType) {
    JHMediaTypeLocaleMedia,
    JHMediaTypeNetMedia,
};
typedef NS_ENUM(NSUInteger, JHSnapshotType) {
    JHSnapshotTypeJPG,
    JHSnapshotTypePNG,
    JHSnapshotTypeBMP,
    JHSnapshotTypeTIFF
};

@class JHMediaPlayer;
@protocol JHMediaPlayerDelegate <NSObject>
@optional
/**
 *  监听时间变化
 *
 *  @param player    Player
 *  @param progress  当前进度
 *  @param fomatTime 格式化之后的时间
 */
- (void)mediaPlayer:(JHMediaPlayer *)player progress:(float)progress formatTime:(NSString *)formatTime;
//只有播放流媒体时才有效
- (void)mediaPlayer:(JHMediaPlayer *)player bufferTimeProgress:(float)progress onceBufferTime:(float)onceBufferTime;

- (void)mediaPlayer:(JHMediaPlayer *)player statusChange:(JHMediaPlayerStatus)status;
@end


@interface JHMediaPlayer : NSObject
@property (strong, nonatomic) JHMediaView *mediaView;
@property (strong, nonatomic) NSURL *mediaURL;
@property (assign, nonatomic) CGFloat volume;
/**
 *  位置 0 ~ 1
 */
@property (assign, nonatomic) CGFloat position;
/**
 *  协议返回的时间格式 默认"mm:ss"
 */
@property (strong, nonatomic) NSString *timeFormat;
@property (weak, nonatomic) id <JHMediaPlayerDelegate>delegate;
- (JHMediaPlayerStatus)status;
- (NSTimeInterval)length;
- (NSTimeInterval)currentTime;
- (JHMediaType)mediaType;
/**
 *  媒体跳转
 *
 *  @param value 增加的值
 */
- (void)jump:(int)value;
/**
 *  音量增加
 *
 *  @param value 增加的值
 */
- (void)volumeJump:(CGFloat)value;
- (void)play;
- (void)pause;
- (void)stop;
/**
 *  保存截图
 *
 *  @param path   路径
 *  @param width  宽 如果填0则为原视频宽
 *  @param height 高 如果填0则为原视频高
 *  @param format 图片格式
 */
- (void)saveVideoSnapshotAt:(NSString *)path withWidth:(NSInteger)width andHeight:(NSInteger)height format:(JHSnapshotType)format;
/**
 *  初始化
 *
 *  @param mediaURL 媒体路径 可以为本地视频或者网络视频
 *
 *  @return self
 */
- (instancetype)initWithMediaURL:(NSURL *)mediaURL;
/**
 *  获取视频尺寸
 *
 *  @param completionHandle 回调
 */
- (void)videoSizeWithCompletionHandle:(void(^)(CGSize size))completionHandle;
@end
