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
@property (assign, nonatomic) NSInteger subtitleDelay;
@property (strong, nonatomic, readonly) NSArray *subtitleIndexs;
@property (strong, nonatomic, readonly) NSArray *subtitleTitles;
@property (assign, nonatomic) int currentSubtitleIndex;
/**
 *  位置 0 ~ 1
 */
- (CGFloat)position;
/**
 *  设置媒体位置
 *
 *  @param position          位置 0 ~ 1
 *  @param completionHandler 完成之后的回调
 */
- (void)setPosition:(CGFloat)position completionHandler:(void(^)(NSTimeInterval time))completionHandler;
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
- (void)jump:(int)value completionHandler:(void(^)(NSTimeInterval time))completionHandler;
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
 *  @param size  宽 如果为 CGSizeZero则为原视频的宽高
 *  @param height 高 如果填0则为原视频高
 *  @param format 图片格式
 */
- (void)saveVideoSnapshotAt:(NSString *)path withSize:(CGSize)size format:(JHSnapshotType)format;
/**
 *  加载字幕文件
 *
 *  @param path 字幕路径
 *
 *  @return 是否成功 0失败 1成功
 */
- (int)openVideoSubTitlesFromFile:(NSString *)path;
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
