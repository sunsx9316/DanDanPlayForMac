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
    NSNumber *__danmakuOpacity;
    NSNumber *__danmakuSpeed;
    NSNumber *__danmakuSpecially;
    NSNumber *__defaultScreenShotType;
    NSNumber *__defaultQuality;
    NSString *_homeImgPath;
    NSString *_screenShotPath;
    NSString *_autoDownLoadPath;
    NSString *_danmakuCachePath;
    NSMutableArray *_userFilterArr;
    NSMutableArray *_customKeyMapArr;
    NSMutableArray *_videoListArr;
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
            [self setShowRecommedInfoAtStart:YES];
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
            [self setAutoDownLoadPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"]];
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
        if (_customKeyMapArr == nil) {
            [self setCustomKeyMapArr:[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_key_map" ofType:@"plist"]]];
        }
    }
    return _customKeyMapArr;
}

- (void)setVideoListArr:(NSArray *)videoListArr {
    _videoListArr = [NSMutableArray arrayWithArray:videoListArr];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_videoListArr] forKey:@"videoList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)videoListArr {
    if (_videoListArr == nil) {
        _videoListArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videoList"]]];
    }
    return _videoListArr;
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

//+ (BOOL)turnOnCaptionsProtectArea{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_isTurnOnCaptionsProtectArea) {
//        return manager->_isTurnOnCaptionsProtectArea.boolValue;
//    }
//    
//    BOOL captionsProtectArea = YES;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"captionsProtectArea"]) {
//        captionsProtectArea = [[NSUserDefaults standardUserDefaults] boolForKey:@"captionsProtectArea"];
//    }
//    else {
//        [self setTurnOnCaptionsProtectArea: YES];
//    }
//    return captionsProtectArea;
//}
//
//+ (void)setTurnOnCaptionsProtectArea:(BOOL)captionsProtectArea {
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_isTurnOnCaptionsProtectArea = @(captionsProtectArea);
//    [[NSUserDefaults standardUserDefaults] setBool:captionsProtectArea forKey:@"captionsProtectArea"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSFont *)danMuFont{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_danMuFont) {
//        return manager->_danMuFont;
//    }
//    
//    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"danMuFont"];
//    NSFont *font = nil;
//    if (!data) {
//        font = [NSFont systemFontOfSize: DANMAKU_FONT_SIZE];
//        [self setDanMuFont: font];
//    }
//    else {
//        font = [NSKeyedUnarchiver unarchiveObjectWithData: data];
//    }
//    return font;
//}
//
//+ (void)setDanMuFont:(NSFont *)danMuFont{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_danMuFont = danMuFont;
//    if (!danMuFont) {
//        danMuFont = [NSFont systemFontOfSize: DANMAKU_FONT_SIZE];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: danMuFont] forKey: @"danMuFont"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSMutableDictionary *)subtitleAttDic {
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    return manager->_subtitleAttDic ? manager->_subtitleAttDic : [NSMutableDictionary dictionary];
//}
//
//+ (void)setSubtitleAttDic:(NSDictionary *)subtitleAttDic {
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_subtitleAttDic = [subtitleAttDic mutableCopy];
//}
//
//+ (CGFloat)danMuOpacity{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_danMuOpacity) {
//        return manager->_danMuOpacity.floatValue;
//    }
//    
//    CGFloat value = 1.0;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuOpacity"]) {
//        value = [[NSUserDefaults standardUserDefaults] floatForKey: @"danMuOpacity"];
//    }
//    else {
//        [self setDanMuOpacity: 1.0];
//    }
//    return value;
//}
//
//+ (void)setDanMuOpacity:(CGFloat)danMuOpacity{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_danMuOpacity = @(danMuOpacity);
//    
//    [[NSUserDefaults standardUserDefaults] setFloat:danMuOpacity forKey:@"danMuOpacity"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (CGFloat)danMuSpeed{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_danMuSpeed) {
//        return manager->_danMuSpeed.floatValue;
//    }
//    
//    CGFloat value = 1.0;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuSpeed"]) {
//        value = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMuSpeed"];
//    }
//    else {
//        [self setDanMuSpeed: 1.0];
//    }
//    return value;
//}
//
//+ (void)setDanMuSpeed:(CGFloat)danMuSpeed{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_danMuSpeed = @(danMuSpeed);
//    
//    [[NSUserDefaults standardUserDefaults] setFloat:danMuSpeed forKey:@"danMuSpeed"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSInteger)danMufontSpecially{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_danMufontSpecially) {
//        return manager->_danMufontSpecially.integerValue;
//    }
//    
//    NSInteger specially = 100;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMufontSpecially"]) {
//        specially = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMufontSpecially"];
//    }
//    else {
//        [self setDanMuFontSpecially: 100];
//    }
//    return specially;
//}
//
//+ (void)setDanMuFontSpecially:(NSInteger)fontSpecially{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_danMufontSpecially = @(fontSpecially);
//    
//    [[NSUserDefaults standardUserDefaults] setInteger:fontSpecially forKey:@"danMufontSpecially"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSImage*)homeImg{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_homeImg) {
//        return manager->_homeImg;
//    }
//    
//    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSUserDefaults standardUserDefaults] stringForKey: @"homeImgPath"]];
//    if (!img) {
//        img = [NSImage imageNamed:@"home"];
//    }
//    return img;
//}
//
//+ (void)setHomeImgPath:(NSString *)homeImgPath{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_homeImg = [[NSImage alloc] initWithContentsOfFile:homeImgPath];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:homeImgPath forKey:@"homeImgPath"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSMutableArray *)userFilter{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_userFilter) {
//        return manager->_userFilter;
//    }
//    
//    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] arrayForKey: @"userFilter"] mutableCopy];
//    return arr?arr:[NSMutableArray array];
//}
//
//+ (void)setUserFilter:(NSMutableArray *)userFilter{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_userFilter = userFilter;
//    
//    [[NSUserDefaults standardUserDefaults] setObject:userFilter forKey:@"userFilter"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSMutableArray *)customKeyMap{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_customKeyMap) {
//        return manager->_customKeyMap;
//    }
//    
//    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"customKeyMap"] mutableCopy];
//    if (!arr) {
//        arr = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_key_map" ofType:@"plist"]] mutableCopy];
//        [self setCustomKeyMap: arr];
//    }
//    return arr;
//}
//
//+ (void)setCustomKeyMap:(NSMutableArray *)customKeyMap{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_customKeyMap = customKeyMap;
//    
//    [[NSUserDefaults standardUserDefaults] setObject:customKeyMap forKey:@"customKeyMap"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSString *)screenShotPath{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_screenShotPath) {
//        return manager->_screenShotPath;
//    }
//    
//    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"screenShotPath"];
//    if (!str) {
//        str = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"];
//        [self setScreenShotPath: str];
//    }
//    return str;
//}
//
//+ (void)setScreenShotPath:(NSString *)screenShotPath{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_screenShotPath = screenShotPath;
//    
//    [[NSUserDefaults standardUserDefaults] setObject:screenShotPath forKey:@"screenShotPath"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSString *)cachePath{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_cachePath) {
//        return manager->_cachePath;
//    }
//    
//    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachePath"];
//    if (!path) {
//        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"];
//        [self setCachePath:path];
//    }
//    return path;
//}
//
//+ (void)setCachePath:(NSString *)cachePath{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_cachePath = cachePath;
//    
//    [[NSUserDefaults standardUserDefaults] setValue:cachePath forKey:@"cachePath"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSInteger)defaultScreenShotType{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_defaultScreenShotType) {
//        return manager->_defaultScreenShotType.integerValue;
//    }
//    
//    NSInteger type = 0;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultScreenShotType"]) {
//        type = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultScreenShotType"];
//    }else{
//        [self setDefaultScreenShotType:0];
//    }
//    return type;
//}
//
//+ (void)setDefaultScreenShotType:(NSInteger)type{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_defaultScreenShotType = @(type);
//    
//    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"defaultScreenShotType"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (BOOL)turnOnFastMatch{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_isTurnOnFastMatch) {
//        return manager->_isTurnOnFastMatch.boolValue;
//    }
//    
//    BOOL isTurnOnFastMatch = YES;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turnOnFastMatch"]) {
//        isTurnOnFastMatch = [[NSUserDefaults standardUserDefaults] boolForKey:@"turnOnFastMatch"];
//    }
//    else {
//        [self setTurnOnFastMatch:YES];
//    }
//    return isTurnOnFastMatch;
//}
//
//+ (void)setTurnOnFastMatch:(BOOL)fastMatch{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_isTurnOnFastMatch = @(fastMatch);
//    [[NSUserDefaults standardUserDefaults] setBool:fastMatch forKey:@"turnOnFastMatch"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSString *)autoDownLoadPath{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_autoDownLoadPath) {
//        return manager->_autoDownLoadPath;
//    }
//    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoDownLoadPath"];
//    if (!path) {
//        path = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES).firstObject;
//        [self setAutoDownLoadPath:path];
//    }
//    return path;
//}
//
//+ (void)setAutoDownLoadPath:(NSString *)path{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    
//    manager->_autoDownLoadPath = path;
//    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"autoDownLoadPath"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (BOOL)cheakDownLoadInfoAtStart{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_cheakDownLoadInfoAtStart) {
//        return manager->_cheakDownLoadInfoAtStart.boolValue;
//    }
//    
//    BOOL isCheakDownLoadInfoAtStart = YES;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cheakDownLoadInfoAtStart"]) {
//        isCheakDownLoadInfoAtStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"cheakDownLoadInfoAtStart"];
//    }
//    else {
//        [self setCheakDownLoadInfoAtStart:YES];
//    }
//    return isCheakDownLoadInfoAtStart;
//}
//
//+ (void)setCheakDownLoadInfoAtStart:(BOOL)cheak{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_isTurnOnFastMatch = @(cheak);
//    [[NSUserDefaults standardUserDefaults] setBool:cheak forKey:@"cheakDownLoadInfoAtStart"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (BOOL)showRecommedInfoAtStart{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_showRecommedInfo) {
//        return manager->_showRecommedInfo.boolValue;
//    }
//    
//    BOOL isShowRecommedInfo = NO;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showRecommedInfoAtStart"]) {
//        isShowRecommedInfo = [[NSUserDefaults standardUserDefaults] boolForKey:@"showRecommedInfoAtStart"];
//    }
//    else {
//        [self setShowRecommedInfoAtStart:NO];
//    }
//    return isShowRecommedInfo;
//}
//
//+ (void)setShowRecommedInfoAtStart:(BOOL)show{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_showRecommedInfo = @(show);
//    [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"showRecommedInfoAtStart"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
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
    
//    if (!hash.length) return -1;
//    
//    if (_lastWatchTimeDic[hash]) {
//        return [_lastWatchTimeDic[hash] floatValue];
//    }
//    
//    _lastWatchTimeDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"lastWatchVideosTime"]];
//    if (_lastWatchTimeDic) {
//        
//    }
//    if (!tempDic) {
//        _lastWatchTimeDic = [NSMutableDictionary dictionary];
//        [[NSUserDefaults standardUserDefaults] setObject:_lastWatchTimeDic forKey:@"lastWatchVideosTime"];
//    }
//    else {
//        _lastWatchTimeDic = [tempDic mutableCopy];
//        return [manager->_lastWatchTimeDic[hash] floatValue];
//    }
    
//    return -1;

}

- (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time {
    if (!hash.length) return;
//    UserDefaultManager *manager = [self shareUserDefaultManager];
    
//    if (!manager->_lastWatchTimeDic) {
//        manager->_lastWatchTimeDic = [@{} mutableCopy];
//    }
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
//
//+ (NSInteger)defaultQuality{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    if (manager->_quality) {
//        return manager->_quality.integerValue;
//    }
//    
//    NSInteger type = 0;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultScreenShotType"]) {
//        type = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultQuality"];
//    }
//    else {
//        [self setDefaultQuality:0];
//    }
//    return type;
//}
//
//+ (void)setDefaultQuality:(NSInteger)quality{
//    UserDefaultManager *manager = [self shareUserDefaultManager];
//    manager->_quality = @(quality);
//    
//    [[NSUserDefaults standardUserDefaults] setInteger:quality forKey:@"defaultQuality"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//

//
//+ (void)setVideoListArr:(NSArray *)videosArr{
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:videosArr] forKey:@"videoList"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSArray *)videoList{
//    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videoList"]];
//}
@end
