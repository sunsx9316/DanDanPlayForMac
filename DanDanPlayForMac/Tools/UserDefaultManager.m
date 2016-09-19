//
//  UserDefaultManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import "UserDefaultManager.h"
@implementation UserDefaultManager
{
    NSNumber *_isTurnOnCaptionsProtectArea;
    NSNumber *_isTurnOnFastMatch;
    NSNumber *_isCheakDownLoadInfoAtStart;
    NSNumber *_isShowRecommedInfoAtStart;
    NSNumber *_isReverseVolumeScroll;
    NSNumber *_isFirstRun;
    NSNumber *__danmakuOpacity;
    NSNumber *__danmakuSpeed;
    NSNumber *__danmakuSpecially;
    NSNumber *__defaultScreenShotType;
    NSNumber *__defaultQuality;
    NSString *_homeImgPath;
    NSString *_screenShotPath;
    NSString *_autoDownLoadPath;
    NSString *_danmakuCachePath;
    VersionModel *_versionModel;
    NSMutableArray *_userFilterArr;
    NSMutableArray *_customKeyMapArr;
    NSMutableOrderedSet *_videoListOrderedSet;
    NSFont *_danmakuFont;
    NSMutableDictionary *_lastWatchTimeDic;
}

+ (instancetype)shareUserDefaultManager {
    static dispatch_once_t onceToken;
    static UserDefaultManager* manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[UserDefaultManager alloc] init];
    });
    return manager;
}

- (void)setTurnOnCaptionsProtectArea:(BOOL)turnOnCaptionsProtectArea {
    _isTurnOnCaptionsProtectArea = @(turnOnCaptionsProtectArea);
    [[NSUserDefaults standardUserDefaults] setBool:turnOnCaptionsProtectArea forKey:@"captionsProtectArea"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)turnOnCaptionsProtectArea {
    if (_isTurnOnCaptionsProtectArea == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"captionsProtectArea"]) {
            _isTurnOnCaptionsProtectArea = @([ud boolForKey:@"captionsProtectArea"]);
        }
        else {
            [self setTurnOnCaptionsProtectArea:YES];
        }
    }
    return _isTurnOnCaptionsProtectArea.boolValue;
}

- (void)setTurnOnFastMatch:(BOOL)turnOnFastMatch {
    _isTurnOnFastMatch = @(turnOnFastMatch);
    [[NSUserDefaults standardUserDefaults] setBool:turnOnFastMatch forKey:@"turnOnFastMatch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)turnOnFastMatch {
    if (_isTurnOnFastMatch == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"turnOnFastMatch"]) {
            _isTurnOnFastMatch = @([ud boolForKey:@"turnOnFastMatch"]);
        }
        else {
            [self setTurnOnFastMatch:YES];
        }
    }
    return _isTurnOnFastMatch.boolValue;
}

- (void)setCheakDownLoadInfoAtStart:(BOOL)cheakDownLoadInfoAtStart {
    _isCheakDownLoadInfoAtStart = @(cheakDownLoadInfoAtStart);
    [[NSUserDefaults standardUserDefaults] setBool:cheakDownLoadInfoAtStart forKey:@"cheakDownLoadInfoAtStart"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)cheakDownLoadInfoAtStart {
    if (_isCheakDownLoadInfoAtStart == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"cheakDownLoadInfoAtStart"]) {
            _isCheakDownLoadInfoAtStart = @([ud boolForKey:@"cheakDownLoadInfoAtStart"]);
        }
        else {
            [self setCheakDownLoadInfoAtStart:YES];
        }
    }
    return _isCheakDownLoadInfoAtStart.boolValue;
}

- (void)setShowRecommedInfoAtStart:(BOOL)showRecommedInfoAtStart {
    _isShowRecommedInfoAtStart = @(showRecommedInfoAtStart);
    [[NSUserDefaults standardUserDefaults] setBool:showRecommedInfoAtStart forKey:@"showRecommedInfoAtStart"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)showRecommedInfoAtStart {
    if (_isShowRecommedInfoAtStart == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"showRecommedInfoAtStart"]) {
            _isShowRecommedInfoAtStart = @([ud boolForKey:@"showRecommedInfoAtStart"]);
        }
        else {
            [self setShowRecommedInfoAtStart:NO];
        }
    }
    return _isShowRecommedInfoAtStart.boolValue;
}

- (void)setReverseVolumeScroll:(BOOL)reverseVolumeScroll {
    _isReverseVolumeScroll = @(reverseVolumeScroll);
    [[NSUserDefaults standardUserDefaults] setBool:reverseVolumeScroll forKey:@"reverseVolumeScroll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)reverseVolumeScroll {
    if (_isReverseVolumeScroll == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"reverseVolumeScroll"]) {
            _isReverseVolumeScroll = @([ud boolForKey:@"reverseVolumeScroll"]);
        }
        else {
            [self setReverseVolumeScroll:NO];
        }
    }
    return _isReverseVolumeScroll.boolValue;
}

- (void)setFirstRun:(BOOL)firstRun {
    _isFirstRun = @(firstRun);
    [[NSUserDefaults standardUserDefaults] setBool:firstRun forKey:@"firstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)firstRun {
    if (_isFirstRun == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"firstRun"]) {
            _isFirstRun = @([ud boolForKey:@"firstRun"]);
        }
        else {
            [self setFirstRun:YES];
        }
    }
    return _isFirstRun.boolValue;
}

- (void)setDanmakuOpacity:(CGFloat)danmakuOpacity {
    __danmakuOpacity = @(danmakuOpacity);
    [[NSUserDefaults standardUserDefaults] setFloat:danmakuOpacity forKey:@"danMuOpacity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)danmakuOpacity {
    if (__danmakuOpacity == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"danMuOpacity"]) {
            __danmakuOpacity = @([ud floatForKey:@"danMuOpacity"]);
        }
        else {
            [self setDanmakuOpacity:1.0];
        }
    }
    return __danmakuOpacity.floatValue;
}

- (void)setDanmakuSpeed:(CGFloat)danmakuSpeed {
    __danmakuSpeed = @(danmakuSpeed);
    [[NSUserDefaults standardUserDefaults] setFloat:danmakuSpeed forKey:@"danMuSpeed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)danmakuSpeed {
    if (__danmakuSpeed == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"danMuSpeed"]) {
            __danmakuSpeed = @([ud floatForKey:@"danMuSpeed"]);
        }
        else {
            [self setDanmakuSpeed:1.0];
        }
    }
    return __danmakuSpeed.floatValue;
}

- (void)setDanmakuSpecially:(NSInteger)danmakuSpecially {
    __danmakuSpecially = @(danmakuSpecially);
    [[NSUserDefaults standardUserDefaults] setInteger:danmakuSpecially forKey:@"danMufontSpecially"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)danmakuSpecially {
    if (__danmakuSpecially == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"danMufontSpecially"]) {
            __danmakuSpecially = @([ud integerForKey:@"danMufontSpecially"]);
        }
        else {
            [self setDanmakuSpecially:100];
        }
    }
    return __danmakuSpecially.floatValue;
}

- (void)setDefaultScreenShotType:(NSInteger)defaultScreenShotType {
    __defaultScreenShotType = @(defaultScreenShotType);
    [[NSUserDefaults standardUserDefaults] setInteger:defaultScreenShotType forKey:@"defaultScreenShotType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)defaultScreenShotType {
    if (__defaultScreenShotType == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"defaultScreenShotType"]) {
            __defaultScreenShotType = @([ud integerForKey:@"defaultScreenShotType"]);
        }
        else {
            [self setDefaultScreenShotType:0];
        }
    }
    return __defaultScreenShotType.integerValue;
}

- (void)setDefaultQuality:(NSInteger)defaultQuality {
    __defaultQuality = @(defaultQuality);
    [[NSUserDefaults standardUserDefaults] setInteger:defaultQuality forKey:@"defaultQuality"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)defaultQuality {
    if (__defaultQuality == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([ud objectForKey:@"defaultQuality"]) {
            __defaultQuality = @([ud integerForKey:@"defaultQuality"]);
        }
        else {
            [self setDefaultQuality:0];
        }
    }
    return __defaultQuality.integerValue;
}

- (void)setHomeImgPath:(NSString *)homeImgPath {
    _homeImgPath = homeImgPath;
    [[NSUserDefaults standardUserDefaults] setObject:_homeImgPath forKey:@"homeImgPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)homeImgPath {
    if (_homeImgPath == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _homeImgPath = [ud objectForKey:@"homeImgPath"];
        
        if (!_homeImgPath.length) {
            [self setHomeImgPath:[[NSBundle mainBundle] pathForResource:@"home" ofType:@"png"]];
        }
    }
    return _homeImgPath;
}

- (void)setScreenShotPath:(NSString *)screenShotPath {
    _screenShotPath = screenShotPath;
    [[NSUserDefaults standardUserDefaults] setObject:_screenShotPath forKey:@"screenShotPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)screenShotPath {
    if (_screenShotPath == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _screenShotPath = [ud objectForKey:@"screenShotPath"];
        
        if (!_screenShotPath.length) {
            [self setScreenShotPath:[NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"]];
        }
    }
    return _screenShotPath;
}

- (void)setAutoDownLoadPath:(NSString *)autoDownLoadPath {
    _autoDownLoadPath = autoDownLoadPath;
    [[NSUserDefaults standardUserDefaults] setObject:_autoDownLoadPath forKey:@"autoDownLoadPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)autoDownLoadPath {
    if (_autoDownLoadPath == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _autoDownLoadPath = [ud objectForKey:@"autoDownLoadPath"];
        
        if (!_autoDownLoadPath.length) {
            [self setAutoDownLoadPath:NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES).firstObject];
        }
    }
    return _autoDownLoadPath;
}

- (NSString *)patchPath {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"patch"];
}

- (void)setVersionModel:(VersionModel *)versionModel {
    _versionModel = versionModel;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_versionModel] forKey:@"versionModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (VersionModel *)versionModel {
    if (_versionModel == nil) {
        _versionModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"versionModel"]];
    }
    return _versionModel;
}

- (void)setDanmakuCachePath:(NSString *)danmakuCachePath {
    _danmakuCachePath = danmakuCachePath;
    [[NSUserDefaults standardUserDefaults] setObject:_danmakuCachePath forKey:@"cachePath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)danmakuCachePath {
    if (_danmakuCachePath == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _danmakuCachePath = [ud objectForKey:@"cachePath"];
        
        if (!_danmakuCachePath.length) {
            [self setDanmakuCachePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"]];
        }
    }
    return _danmakuCachePath;
}

- (void)setUserFilterArr:(NSMutableArray *)userFilterArr {
    _userFilterArr = userFilterArr;
    [[NSUserDefaults standardUserDefaults] setObject:_userFilterArr forKey:@"userFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)userFilterArr {
    if (_userFilterArr == nil) {
        _userFilterArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"userFilter"]];
    }
    return _userFilterArr;
}

- (void)setCustomKeyMapArr:(NSMutableArray *)customKeyMapArr {
    _customKeyMapArr = customKeyMapArr;
    [[NSUserDefaults standardUserDefaults] setObject:_customKeyMapArr forKey:@"customKeyMap"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)customKeyMapArr {
    if (_customKeyMapArr == nil) {
        _customKeyMapArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"customKeyMap"]];
        if (_customKeyMapArr.count == 0) {
            [self setCustomKeyMapArr:[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_key_map" ofType:@"plist"]]];
        }
        
        for (NSInteger i = 0; i < _customKeyMapArr.count; ++i) {
            [_customKeyMapArr replaceObjectAtIndex:i withObject:[_customKeyMapArr[i] mutableCopy]];
        }
    }
    return _customKeyMapArr;
}

- (void)setVideoListOrderedSet:(NSMutableOrderedSet *)videoListOrderedSet {
    _videoListOrderedSet = videoListOrderedSet;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_videoListOrderedSet] forKey:@"videoList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableOrderedSet *)videoListOrderedSet {
    if (_videoListOrderedSet == nil) {
        _videoListOrderedSet = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videoList"]];
        if (_videoListOrderedSet == nil) {
            _videoListOrderedSet = [NSMutableOrderedSet orderedSet];
        }
    }
    return _videoListOrderedSet;
}

- (void)setDanmakuFont:(NSFont *)danmakuFont {
    _danmakuFont = danmakuFont;
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: _danmakuFont] forKey: @"danMuFont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSFont *)danmakuFont {
    if (_danmakuFont == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"danMuFont"];
        _danmakuFont = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        if (_danmakuFont == nil) {
            [self setDanmakuFont:[NSFont systemFontOfSize: DANMAKU_FONT_SIZE]];
        }
    }
    return _danmakuFont;
}

- (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash {
    //-1表示没有播放过
    if (!hash.length) return -1;
    
    if (_lastWatchTimeDic == nil) {
        _lastWatchTimeDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"lastWatchVideosTime"]];
    }
    
    if (_lastWatchTimeDic[hash]) {
        return [_lastWatchTimeDic[hash] floatValue];
    }
    
    return -1;

}

- (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time {
    if (!hash.length) return;

    if (time < 0) {
        _lastWatchTimeDic[hash] = nil;
    }
    else {
        _lastWatchTimeDic[hash] = @(time);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_lastWatchTimeDic forKey:@"lastWatchVideosTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearPlayHistory {
    _lastWatchTimeDic = [NSMutableDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastWatchVideosTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)userSentDanmaukuArrWithEpisodeId:(NSString *)episodeId {
    return [NSMutableArray arrayWithArray: [NSKeyedUnarchiver unarchiveObjectWithFile: [self userDanmakuCachePathWithEpisodeId: episodeId]]];
}

+ (void)saveUserSentDanmakus:(NSArray *)sentDanmakus episodeId:(NSString *)episodeId {
    if (sentDanmakus == nil || episodeId.length == 0) return;
    
    [NSKeyedArchiver archiveRootObject:sentDanmakus toFile:[self userDanmakuCachePathWithEpisodeId: episodeId]];
}

#pragma mark - 私有方法
+ (NSString *)userDanmakuCachePathWithEpisodeId:(NSString *)episodeId {
    NSString *path = [ToolsManager stringValueWithDanmakuSource:DanDanPlayDanmakuSourceOfficial];
    return [[UserDefaultManager shareUserDefaultManager].danmakuCachePath stringByAppendingPathComponent:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_user", episodeId]]];
}

@end
