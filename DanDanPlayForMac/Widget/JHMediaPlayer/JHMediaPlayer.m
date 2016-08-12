//
//  JHMediaPlayer.m
//  test
//
//  Created by JimHuang on 16/3/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHMediaPlayer.h"
#import "JHVLCMedia.h"
#import "JHPlayerItem.h"
#import "VLCMedia+Tools.h"
#import <VLCKit/VLCKit.h>
#import <AVFoundation/AVFoundation.h>
//最大音量
#define MAX_VOLUME 200.0

@interface JHMediaPlayer()<VLCMediaPlayerDelegate, JHPlayerItemDelegate>
@property (strong, nonatomic) VLCMediaPlayer *localMediaPlayer;
@property (strong, nonatomic) AVPlayer *netMediaPlayer;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation JHMediaPlayer
{
    NSTimeInterval _length;
    NSTimeInterval _currentTime;
    id _timeObj;
    JHMediaPlayerStatus _status;
    BOOL _isBuffer;
}

#pragma mark 属性

- (JHMediaType)mediaType{
    return [self.mediaURL isFileURL] ? JHMediaTypeLocaleMedia : JHMediaTypeNetMedia;
}

- (void)videoSizeWithCompletionHandle:(void(^)(CGSize size))completionHandle{
    if (self.mediaType == JHMediaTypeNetMedia){
        if (!self.mediaURL) {
            self.localMediaPlayer.currentVideoSubTitleDelay = 0;
            completionHandle(CGSizeMake(-1, -1));
            return;
        }
        completionHandle(CGSizeZero);
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.mediaURL.path]) {
        completionHandle(CGSizeMake(-1, -1));
        return;
    }
    
    JHVLCMedia *media = (JHVLCMedia *)self.localMediaPlayer.media;
    if (media.parsedStatus == VLCMediaParsedStatusInit) {
        [media parseWithBlock:^(VLCMedia *aMedia) {
            completionHandle(aMedia.videoSize);
        }];
    }
    else {
        completionHandle(media.videoSize);
    }
}

- (NSTimeInterval)length {
    if (_length >= 0) return _length;
    
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        _length = self.localMediaPlayer.media.length.numberValue.floatValue / 1000;
    }
    else{
        _length = CMTimeGetSeconds(self.netMediaPlayer.currentItem.duration);
    }
    return _length;
}

- (NSTimeInterval)currentTime {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return self.localMediaPlayer.time.numberValue.floatValue / 1000;
    }
    return CMTimeGetSeconds(self.netMediaPlayer.currentTime);
}

- (JHMediaPlayerStatus)status {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        switch (self.localMediaPlayer.state) {
            case VLCMediaPlayerStateStopped:
                _status = JHMediaPlayerStatusStop;
                break;
            case VLCMediaPlayerStatePaused:
                _status = JHMediaPlayerStatusPause;
                break;
            default:
                _status = JHMediaPlayerStatusPlaying;
                break;
        }
        return _status;
    }
    
    _status = (self.netMediaPlayer.rate == 0 || isnan([self netMediaBufferOnceTime])) ? JHMediaPlayerStatusPause : JHMediaPlayerStatusPlaying;
    return _status;
}

#pragma mark 音量
- (void)volumeJump:(CGFloat)value {
    [self setVolume: self.volume + value];
}

- (CGFloat)volume {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return self.localMediaPlayer.audio.volume;
    }
    return self.netMediaPlayer.volume * MAX_VOLUME;
}

- (void)setVolume:(CGFloat)volume {
    if (volume < 0) volume = 0;
    if (volume > MAX_VOLUME) volume = MAX_VOLUME;
    
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        self.localMediaPlayer.audio.volume = volume;
    }
    else {
        self.netMediaPlayer.volume = volume / MAX_VOLUME;
    }
}

#pragma mark 播放位置
- (void)jump:(int)value completionHandler:(void(^)(NSTimeInterval time))completionHandler {
    [self setPosition:([self currentTime] + value) / [self length] completionHandler:completionHandler];
}

- (void)setPosition:(CGFloat)position completionHandler:(void(^)(NSTimeInterval time))completionHandler {
    if (position < 0) position = 0;
    if (position > 1) position = 1;
    
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        self.localMediaPlayer.position = position;
        if (completionHandler) completionHandler([self length] * position);
    }
    else {
        CMTime time = self.netMediaPlayer.currentTime;
        time.value = time.timescale * position * [self length];
        __weak typeof(self)weakSelf = self;
        [self.netMediaPlayer seekToTime:time completionHandler:^(BOOL finished) {
            if (completionHandler) completionHandler([weakSelf currentTime]);
        }];
    }
}

- (CGFloat)position {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return self.localMediaPlayer.position;
    }
    return [self currentTime] / [self length];
}

#pragma mark 字幕
- (void)setSubtitleDelay:(NSInteger)subtitleDelay {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        self.localMediaPlayer.currentVideoSubTitleDelay = subtitleDelay;
    }
}

- (NSInteger)subtitleDelay {
    return self.localMediaPlayer.currentVideoSubTitleDelay;
}

- (NSArray *)subtitleIndexs {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return self.localMediaPlayer.videoSubTitlesIndexes;
    }
    return nil;
}

- (NSArray *)subtitleTitles {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return self.localMediaPlayer.videoSubTitlesNames;
    }
    return nil;
}

- (void)setCurrentSubtitleIndex:(int)currentSubtitleIndex {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        self.localMediaPlayer.currentVideoSubTitleIndex = currentSubtitleIndex;
    }
}

- (int)currentSubtitleIndex {
    return self.mediaType == JHMediaTypeLocaleMedia ? self.localMediaPlayer.currentVideoSubTitleIndex : 0;
}

#pragma mark 播放器控制
- (void)play {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [self.localMediaPlayer play];
    }
    else {
        [self.netMediaPlayer play];
    }
}

- (void)pause {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [self.localMediaPlayer pause];
    }
    else {
        [self.netMediaPlayer pause];
    }
}

- (void)stop {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [_localMediaPlayer stop];
    }
    else {
        [_netMediaPlayer replaceCurrentItemWithPlayerItem:nil];
    }
}


#pragma mark 功能
- (void)saveVideoSnapshotAt:(NSString *)path withSize:(CGSize)size format:(JHSnapshotType)format {
    //vlc截图方式
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        NSString *directoryPath = [path stringByDeletingLastPathComponent];
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [self.localMediaPlayer saveVideoSnapshotAt:path withWidth:size.width andHeight:size.height];
        NSDictionary *dic = [self imgSuffixNameAndFIleTypeWithformat:format];
        [self transformImgWithPath:path imgFileType:[dic[@"imgFileType"] integerValue] suffixName:dic[@"suffixName"]];
    }
}

- (int)openVideoSubTitlesFromFile:(NSString *)path {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return [self.localMediaPlayer addPlaybackSlave:[NSURL fileURLWithPath:path] type:VLCMediaPlaybackSlaveTypeSubtitle enforce:YES];
    }
    return 0;
}

- (void)setMediaURL:(NSURL *)mediaURL {
    [self stop];
    if (!mediaURL.path.length) return;
    _mediaURL = mediaURL;
    if ([_mediaURL isFileURL]) {
        JHVLCMedia *media = [[JHVLCMedia alloc] initWithURL:mediaURL];
        self.localMediaPlayer.media = media;
        self.localMediaPlayer.delegate = self;
    }
    else {
        [self setupNetMediaPlayerWithMediaURL:_mediaURL];
    }
    _length = -1;
}

- (instancetype)initWithMediaURL:(NSURL *)mediaURL {
    if (self = [super init]) {
        [self setMediaURL:mediaURL];
    }
    return self;
}

#pragma mark - VLCMediaPlayerDelegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:progress:formatTime:)]) {
        NSTimeInterval nowTime = [self currentTime];
        NSTimeInterval videoTime = [self length];
        NSString *nowDateTime = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:nowTime]];
        NSString *videoDateTime = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]];
        if (!(videoDateTime && nowDateTime)) return;
        [self.delegate mediaPlayer:self progress:nowTime / videoTime formatTime:[NSString stringWithFormat:@"%@/%@", nowDateTime, videoDateTime]];
    }
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
        if ([self status] == JHMediaPlayerStatusPause && [self length] - [self currentTime] < 1) {
            //[self.delegate mediaPlayer:self statusChange:JHMediaPlayerStatusStop];
        }else{
            [self.delegate mediaPlayer:self statusChange:[self status]];
        }
    }
}

#pragma mark - JHPlayerItemDelegate
- (void)JHPlayerItem:(JHPlayerItem *)item bufferStartTime:(NSTimeInterval)bufferStartTime bufferOnceTime:(NSTimeInterval)bufferOnceTime {
    [self.delegate mediaPlayer:self bufferTimeProgress:(bufferStartTime + bufferOnceTime) / [self length] onceBufferTime:bufferOnceTime];
}

#pragma mark - 私有方法

#pragma mark 单次缓冲时长
- (NSTimeInterval)netMediaBufferOnceTime{
    CMTimeRange range = self.netMediaPlayer.currentItem.loadedTimeRanges.firstObject.CMTimeRangeValue;
    return CMTimeGetSeconds(range.duration);
}

#pragma mark 播放结束
- (void)playEnd {
    if (self.mediaType == JHMediaTypeNetMedia) {
        _status = JHMediaPlayerStatusStop;
        if ([self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
            [self.delegate mediaPlayer:self statusChange:JHMediaPlayerStatusStop];
        }
    }
}

#pragma mark 转换图片格式
- (void)transformImgWithPath:(NSString *)path imgFileType:(NSBitmapImageFileType)imgFileType suffixName:(NSString *)suffixName {
    if (imgFileType == NSPNGFileType) {
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:[path stringByAppendingPathExtension:@"png"] error:nil];
    }
    else {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
        if (!image) return;
        CGImageRef cgRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[self imgDataWithImageRef:cgRef size:[image size] imgFileType:imgFileType] writeToFile:[NSString stringWithFormat:@"%@%@",path,suffixName] atomically:YES];
        });
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark 获取图片数据
- (NSData *)imgDataWithImageRef:(CGImageRef)imageRef size:(CGSize)size imgFileType:(NSBitmapImageFileType)imgFileType {
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    [newRep setSize:size];
    return [newRep representationUsingType:imgFileType properties: @{}];
}

#pragma mark 获取图片格式和后缀名
- (NSDictionary *)imgSuffixNameAndFIleTypeWithformat:(JHSnapshotType)format {
    NSBitmapImageFileType imgFileType = NSPNGFileType;
    NSString *suffixName = @".png";
    switch (format) {
        case JHSnapshotTypeJPG:
            imgFileType = NSJPEGFileType;
            suffixName = @".jpg";
            break;
        case JHSnapshotTypePNG:
            break;
        case JHSnapshotTypeBMP:
            imgFileType = NSBMPFileType;
            suffixName = @".bmp";
            break;
        case JHSnapshotTypeTIFF:
            imgFileType = NSTIFFFileType;
            suffixName = @".tiff";
            break;
        default:
            break;
    }
    return @{@"suffixName":suffixName, @"imgFileType":@(imgFileType)};
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //播放状态
    if ([keyPath isEqualToString:@"rate"] && [self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
        [self.delegate mediaPlayer:self statusChange:[self status]];
    }
}

- (void)setupNetMediaPlayerWithMediaURL:(NSURL *)mediaURL {
    JHPlayerItem *item = [[JHPlayerItem alloc] initWithURL:mediaURL];
    item.delegate = self;
    if (_netMediaPlayer) {
        [_netMediaPlayer replaceCurrentItemWithPlayerItem:item];
    }
    else {
        _netMediaPlayer = [AVPlayer playerWithPlayerItem:item];
        __weak typeof(self)weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        //监听状态变化
        [_netMediaPlayer addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
        //监听时间变化
        _timeObj = [_netMediaPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf mediaPlayerTimeChanged:nil];
        }];
    }
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_netMediaPlayer];
    self.mediaView.layer = playerLayer;
    
}

- (void)dealloc {
    [_netMediaPlayer removeTimeObserver:_timeObj];
    [_mediaView removeFromSuperview];
    [_netMediaPlayer removeObserver:self forKeyPath:@"rate"];
    [_netMediaPlayer replaceCurrentItemWithPlayerItem:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 懒加载
- (VLCMediaPlayer *)localMediaPlayer {
    if(_localMediaPlayer == nil) {
        VLCVideoLayer *layer = [[VLCVideoLayer alloc] init];
        self.mediaView.layer = layer;
        _localMediaPlayer = [[VLCMediaPlayer alloc] initWithVideoLayer:layer];
//        _localMediaPlayer.libraryInstance.debugLogging = NO;
        _localMediaPlayer.drawable = self.mediaView;
        _localMediaPlayer.delegate = self;
        
    }
    return _localMediaPlayer;
}

- (JHMediaView *)mediaView {
    if (_mediaView == nil) {
        _mediaView = [[JHMediaView alloc] init];
        [_mediaView setWantsLayer:YES];
    }
    return _mediaView;
}

- (NSDateFormatter *)dateFormatter {
    if(_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = _timeFormat?_timeFormat:@"mm:ss";
    }
    return _dateFormatter;
}

@end
