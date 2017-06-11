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
    BOOL _isUserPause;
    BOOL _isBuffering;
    JHVLCMedia *_currentLocalMedia;
}


#pragma mark 属性

- (JHMediaType)mediaType {
    return [self.mediaURL isFileURL] ? JHMediaTypeLocaleMedia : JHMediaTypeNetMedia;
}

- (void)videoSizeWithCompletionHandle:(void(^)(CGSize size))completionHandle {
    if (self.mediaType == JHMediaTypeNetMedia) {
        if (!self.mediaURL) {
            _localMediaPlayer.currentVideoSubTitleDelay = 0;
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
    
    [_currentLocalMedia parseWithBlock:^(CGSize size) {
        completionHandle(size);
    }];
}

- (NSTimeInterval)length {
    if (_length >= 0) return _length;
    
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        _length = _localMediaPlayer.media.length.value.floatValue / 1000;
    }
    else {
        _length = CMTimeGetSeconds(_netMediaPlayer.currentItem.duration);
    }
    return _length;
}

- (NSTimeInterval)currentTime {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return _localMediaPlayer.time.value.floatValue / 1000;
    }
    return CMTimeGetSeconds(_netMediaPlayer.currentTime);
}

- (JHMediaPlayerStatus)status {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        switch (_localMediaPlayer.state) {
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
    
    //用户点击暂停
    if (_isUserPause || _netMediaPlayer.rate == 0) {
        return JHMediaPlayerStatusPause;
    }
    //暂停状态
    else if (_isBuffering) {
        return JHMediaPlayerStatusBuffering;
    }
    return JHMediaPlayerStatusPlaying;
}

#pragma mark 音量
- (void)volumeJump:(CGFloat)value {
    [self setVolume: self.volume + value];
}

- (CGFloat)volume {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return _localMediaPlayer.audio.volume;
    }
    return _netMediaPlayer.volume * MAX_VOLUME;
}

- (void)setVolume:(CGFloat)volume {
    if (volume < 0) volume = 0;
    if (volume > MAX_VOLUME) volume = MAX_VOLUME;
    
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        _localMediaPlayer.audio.volume = volume;
    }
    else {
        _netMediaPlayer.volume = volume / MAX_VOLUME;
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
        _localMediaPlayer.position = position;
        if (completionHandler) completionHandler([self length] * position);
    }
    else {
        CMTime time = _netMediaPlayer.currentTime;
        time.value = time.timescale * position * [self length];
//        __weak typeof(self)weakSelf = self;
        @weakify(self)
        [_netMediaPlayer seekToTime:time completionHandler:^(BOOL finished) {
            @strongify(self)
            if (!self) return;
            
            if (completionHandler) completionHandler([self currentTime]);
        }];
    }
}

- (CGFloat)position {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return _localMediaPlayer.position;
    }
    return [self currentTime] / [self length];
}

#pragma mark 字幕
- (void)setSubtitleDelay:(NSInteger)subtitleDelay {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        _localMediaPlayer.currentVideoSubTitleDelay = subtitleDelay;
    }
}

- (NSInteger)subtitleDelay {
    return _localMediaPlayer.currentVideoSubTitleDelay;
}

- (NSArray *)subtitleIndexs {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return _localMediaPlayer.videoSubTitlesIndexes;
    }
    return nil;
}

- (NSArray *)subtitleTitles {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return _localMediaPlayer.videoSubTitlesNames;
    }
    return nil;
}

- (void)setCurrentSubtitleIndex:(int)currentSubtitleIndex {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        _localMediaPlayer.currentVideoSubTitleIndex = currentSubtitleIndex;
    }
}

- (int)currentSubtitleIndex {
    return self.mediaType == JHMediaTypeLocaleMedia ? _localMediaPlayer.currentVideoSubTitleIndex : 0;
}

#pragma mark 播放器控制
- (void)play {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [_localMediaPlayer play];
    }
    else if (_isBuffering == NO) {
        _isUserPause = NO;
        _isBuffering = NO;
        [_netMediaPlayer play];
    }
    else {
        [self.delegate mediaPlayer:self statusChange:JHMediaPlayerStatusBuffering];
    }
}

- (void)pause {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [_localMediaPlayer pause];
    }
    else {
        _isUserPause = YES;
        [_netMediaPlayer pause];
    }
}

- (void)stop {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [_localMediaPlayer stop];
        _currentLocalMedia = nil;
    }
    else {
        [_netMediaPlayer replaceCurrentItemWithPlayerItem:nil];
    }
}


#pragma mark 功能
- (void)saveVideoSnapshotAt:(NSString *)path withSize:(CGSize)size format:(JHSnapshotType)format completionHandler:(snapshotCompleteBlock)completion {
    //vlc截图方式
    NSError *error = nil;
    NSString *directoryPath = [path stringByDeletingLastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    //创建文件错误
    if (error) {
        completion(nil, error);
        return;
    }
    
    //属性字典
    NSDictionary *dic = [self imgSuffixNameAndFIleTypeWithformat:format];
    
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        [_localMediaPlayer saveVideoSnapshotAt:path withWidth:size.width andHeight:size.height];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            CGImageRef cgRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
            [self transformImgWithPath:path imageRef:cgRef size:image.size imgFileType:[dic[@"imgFileType"] integerValue] suffixName:dic[@"suffixName"] complete:completion];
        });
    }
    else {
        AVAsset *asset = _netMediaPlayer.currentItem.asset;
        AVAssetTrack *track = asset.tracks.firstObject;
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            size = track.naturalSize;
        }
        // 根据视频的URL创建AVURLAsset
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:self.mediaURL options:nil];
        // 根据AVURLAsset创建AVAssetImageGenerator对象
        AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset: urlAsset];
        gen.appliesPreferredTrackTransform = YES;
        // 当前时间视频截图
        CMTime time = _netMediaPlayer.currentItem.currentTime;
        NSError *error = nil;
        CMTime actualTime;
        // 获取time处的视频截图
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        [self transformImgWithPath:path imageRef:image size:size imgFileType:[dic[@"imgFileType"] integerValue] suffixName:dic[@"suffixName"] complete:completion];
    }
}

- (int)openVideoSubTitlesFromFile:(NSString *)path {
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        return [_localMediaPlayer addPlaybackSlave:[NSURL fileURLWithPath:path] type:VLCMediaPlaybackSlaveTypeSubtitle enforce:YES];
    }
    return 0;
}

- (void)setMediaURL:(NSURL *)mediaURL {
    [self stop];
    if (!mediaURL) return;
    _mediaURL = mediaURL;
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:_mediaURL.path]) {
            _currentLocalMedia = [[JHVLCMedia alloc] initWithURL:mediaURL];
            self.localMediaPlayer.media = _currentLocalMedia;
            self.localMediaPlayer.delegate = self;
        }
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
//        if ([self status] == JHMediaPlayerStatusPause && [self length] - [self currentTime] < 1) {
//            //[self.delegate mediaPlayer:self statusChange:JHMediaPlayerStatusStop];
//        }
//        else {
            [self.delegate mediaPlayer:self statusChange:[self status]];
//        }
    }
}

#pragma mark - JHPlayerItemDelegate
- (void)JHPlayerItem:(JHPlayerItem *)item bufferStartTime:(NSTimeInterval)bufferStartTime bufferOnceTime:(NSTimeInterval)bufferOnceTime {
    [self.delegate mediaPlayer:self bufferTimeProgress:(bufferStartTime + bufferOnceTime) / [self length] onceBufferTime:bufferOnceTime];
    if (_isBuffering && bufferOnceTime > 3) {
        _isBuffering = NO;
        [_netMediaPlayer play];
        [self.delegate mediaPlayer:self statusChange:[self status]];
    }
}

#pragma mark - 私有方法
#pragma mark 单次缓冲时长
- (NSTimeInterval)netMediaBufferOnceTime {
    CMTimeRange range = _netMediaPlayer.currentItem.loadedTimeRanges.firstObject.CMTimeRangeValue;
    return CMTimeGetSeconds(range.duration);
}

#pragma mark 在线视频进入缓冲状态
- (void)videoBuffering {
    _isBuffering = YES;
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
        [self.delegate mediaPlayer:self statusChange:JHMediaPlayerStatusBuffering];
    }
}

#pragma mark 播放结束
- (void)playEnd:(NSNotification *)sender {
    if (self.mediaType == JHMediaTypeNetMedia) {
        _status = JHMediaPlayerStatusStop;
        if ([self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
            [self.delegate mediaPlayer:self statusChange:JHMediaPlayerStatusStop];
        }
    }
}

#pragma mark 转换图片格式
- (void)transformImgWithPath:(NSString *)path imageRef:(CGImageRef)imageRef size:(CGSize)size imgFileType:(NSBitmapImageFileType)imgFileType suffixName:(NSString *)suffixName complete:(snapshotCompleteBlock)complete {
    __block NSError *error = nil;
    if (self.mediaType == JHMediaTypeLocaleMedia) {
        if (imgFileType == NSPNGFileType) {
            [[NSFileManager defaultManager] moveItemAtPath:path toPath:[path stringByAppendingPathExtension:@"png"] error:&error];
            if (error) {
                complete(nil, error);
                return;
            }
        }
        else {
            if (!imageRef) return;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[self imgDataWithImageRef:imageRef size:size imgFileType:imgFileType] writeToFile:[NSString stringWithFormat:@"%@%@", path, suffixName] options:NSDataWritingAtomic error:&error];
                complete(path, error);
            });
        }
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            complete(nil, error);
            return;
        }
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[self imgDataWithImageRef:imageRef size:size imgFileType:imgFileType] writeToFile:[NSString stringWithFormat:@"%@%@", path, suffixName] options:NSDataWritingAtomic error:&error];
            complete(path, error);
        });
    }
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoBuffering) name:AVPlayerItemPlaybackStalledNotification object:nil];
        //监听状态变化
        [_netMediaPlayer addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
        //监听时间变化
        @weakify(self)
        _timeObj = [_netMediaPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            @strongify(self)
            if (!self) return;
            
            [self mediaPlayerTimeChanged:nil];
        }];
    }
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_netMediaPlayer];
    self.mediaView.layer = playerLayer;
    [self videoBuffering];
}

- (void)dealloc {
    _currentLocalMedia = nil;
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
        _localMediaPlayer.libraryInstance.debugLogging = NO;
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
