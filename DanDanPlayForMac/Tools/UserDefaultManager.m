//
//  UserDefaultManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
static UserDefaultManager* manager = nil;
#import "UserDefaultManager.h"

@implementation UserDefaultManager
{
    NSNumber *_isTurnOnCaptionsProtectArea;
    NSFont *_danMuFont;
    NSNumber *_danMuOpacity;
    NSNumber *_danMuSpeed;
    NSNumber *_danMufontSpecially;
    NSImage *_homeImg;
    NSMutableArray *_userFilter;
    NSMutableArray *_customKeyMap;
    NSString *_screenShotPath;
    NSNumber *_shouldClearCache;
    NSString *_cachePath;
    NSNumber *_defaultScreenShotType;
    NSNumber *_isTurnOnFastMatch;
    NSString *_autoDownLoadPath;
    NSNumber *_cheakDownLoadInfoAtStart;
    NSNumber *_showRecommedInfo;
    NSNumber *_quality;
    NSMutableDictionary *_lastWatchTimeDic;
}
+ (instancetype)shareUserDefaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [UserDefaultManager new];
    });
    return manager;
}

+ (BOOL)turnOnCaptionsProtectArea{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_isTurnOnCaptionsProtectArea) {
        return manager->_isTurnOnCaptionsProtectArea.boolValue;
    }
    
    BOOL captionsProtectArea = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"captionsProtectArea"]) {
        captionsProtectArea = [[NSUserDefaults standardUserDefaults] boolForKey:@"captionsProtectArea"];
    }else{
        [self setTurnOnCaptionsProtectArea: YES];
    }
    return captionsProtectArea;
}
+ (void)setTurnOnCaptionsProtectArea:(BOOL)captionsProtectArea{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_isTurnOnCaptionsProtectArea = @(captionsProtectArea);
    [[NSUserDefaults standardUserDefaults] setBool:captionsProtectArea forKey:@"captionsProtectArea"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSFont *)danMuFont{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_danMuFont) {
        return manager->_danMuFont;
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"danMuFont"];
    NSFont *font = nil;
    if (!data) {
        font = [NSFont systemFontOfSize: 25];
        [self setDanMuFont: font];
    }else{
        font = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    }
    return font;
}
+ (void)setDanMuFont:(NSFont *)danMuFont{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_danMuFont = danMuFont;
    if (!danMuFont) {
        danMuFont = [NSFont systemFontOfSize: 25];
    }
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: danMuFont] forKey: @"danMuFont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)danMuOpacity{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_danMuOpacity) {
        return manager->_danMuOpacity.floatValue;
    }
    
    CGFloat value = 1.0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuOpacity"]) {
        value = [[NSUserDefaults standardUserDefaults] floatForKey: @"danMuOpacity"];
    }else{
        [self setDanMuOpacity: 1.0];
    }
    return value;
}
+ (void)setDanMuOpacity:(CGFloat)danMuOpacity{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_danMuOpacity = @(danMuOpacity);
    
    [[NSUserDefaults standardUserDefaults] setFloat:danMuOpacity forKey:@"danMuOpacity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)danMuSpeed{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_danMuSpeed) {
        return manager->_danMuSpeed.floatValue;
    }
    
    CGFloat value = 1.0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuSpeed"]) {
        value = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMuSpeed"];
    }else{
        [self setDanMuSpeed: 1.0];
    }
    return value;
}
+ (void)setDanMuSpeed:(CGFloat)danMuSpeed{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_danMuSpeed = @(danMuSpeed);
    
    [[NSUserDefaults standardUserDefaults] setFloat:danMuSpeed forKey:@"danMuSpeed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)danMufontSpecially{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_danMufontSpecially) {
        return manager->_danMufontSpecially.integerValue;
    }
    
    NSInteger specially = 100;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMufontSpecially"]) {
        specially = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMufontSpecially"];
    }else{
        [self setDanMuFontSpecially: 100];
    }
    return specially;
}
+ (void)setDanMuFontSpecially:(NSInteger)fontSpecially{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_danMufontSpecially = @(fontSpecially);
    
    [[NSUserDefaults standardUserDefaults] setInteger:fontSpecially forKey:@"danMufontSpecially"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSImage*)homeImg{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_homeImg) {
        return manager->_homeImg;
    }
    
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSUserDefaults standardUserDefaults] stringForKey: @"homeImgPath"]];
    if (!img) {
        img = [NSImage imageNamed:@"home"];
    }
    return img;
}
+ (void)setHomeImgPath:(NSString *)homeImgPath{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_homeImg = [[NSImage alloc] initWithContentsOfFile:homeImgPath];
    
    [[NSUserDefaults standardUserDefaults] setObject:homeImgPath forKey:@"homeImgPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)userFilter{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_userFilter) {
        return manager->_userFilter;
    }
    
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] arrayForKey: @"userFilter"] mutableCopy];
    return arr?arr:[NSMutableArray array];
}
+ (void)setUserFilter:(NSMutableArray *)userFilter{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_userFilter = userFilter;
    
    [[NSUserDefaults standardUserDefaults] setObject:userFilter forKey:@"userFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)customKeyMap{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_customKeyMap) {
        return manager->_customKeyMap;
    }
    
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"customKeyMap"] mutableCopy];
    if (!arr) {
        arr = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultKeyMap" ofType:@"plist"]] mutableCopy];
        [self setCustomKeyMap: arr];
    }
    return arr;
}
+ (void)setCustomKeyMap:(NSMutableArray *)customKeyMap{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_customKeyMap = customKeyMap;
    
    [[NSUserDefaults standardUserDefaults] setObject:customKeyMap forKey:@"customKeyMap"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)screenShotPath{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_screenShotPath) {
        return manager->_screenShotPath;
    }
    
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"screenShotPath"];
    if (!str) {
        str = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"];
        [self setScreenShotPath: str];
    }
    return str;
}
+ (void)setScreenShotPath:(NSString *)screenShotPath{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_screenShotPath = screenShotPath;
    
    [[NSUserDefaults standardUserDefaults] setObject:screenShotPath forKey:@"screenShotPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cachePath{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_cachePath) {
        return manager->_cachePath;
    }
    
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachePath"];
    if (!path) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"];
        [self setCachePath:path];
    }
    return path;
}

+ (void)setCachePath:(NSString *)cachePath{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_cachePath = cachePath;
    
    [[NSUserDefaults standardUserDefaults] setValue:cachePath forKey:@"cachePath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)defaultScreenShotType{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_defaultScreenShotType) {
        return manager->_defaultScreenShotType.integerValue;
    }
    
    NSInteger type = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultScreenShotType"]) {
        type = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultScreenShotType"];
    }else{
        [self setDefaultScreenShotType:0];
    }
    return type;
}
+ (void)setDefaultScreenShotType:(NSInteger)type{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_defaultScreenShotType = @(type);
    
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"defaultScreenShotType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)turnOnFastMatch{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_isTurnOnFastMatch) {
        return manager->_isTurnOnFastMatch.boolValue;
    }
    
    BOOL isTurnOnFastMatch = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turnOnFastMatch"]) {
        isTurnOnFastMatch = [[NSUserDefaults standardUserDefaults] boolForKey:@"turnOnFastMatch"];
    }else{
        [self setTurnOnFastMatch:YES];
    }
    return isTurnOnFastMatch;
}
+ (void)setTurnOnFastMatch:(BOOL)fastMatch{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_isTurnOnFastMatch = @(fastMatch);
    [[NSUserDefaults standardUserDefaults] setBool:fastMatch forKey:@"turnOnFastMatch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)autoDownLoadPath{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_autoDownLoadPath) {
        return manager->_autoDownLoadPath;
    }
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoDownLoadPath"];
    if (!path) {
        path = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES).firstObject;
        [self setAutoDownLoadPath:path];
    }
    return path;
}
+ (void)setAutoDownLoadPath:(NSString *)path{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    manager->_autoDownLoadPath = path;
    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"autoDownLoadPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)cheakDownLoadInfoAtStart{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_cheakDownLoadInfoAtStart) {
        return manager->_cheakDownLoadInfoAtStart.boolValue;
    }
    
    BOOL isCheakDownLoadInfoAtStart = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cheakDownLoadInfoAtStart"]) {
        isCheakDownLoadInfoAtStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"cheakDownLoadInfoAtStart"];
    }else{
        [self setCheakDownLoadInfoAtStart:YES];
    }
    return isCheakDownLoadInfoAtStart;
}
+ (void)setCheakDownLoadInfoAtStart:(BOOL)cheak{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_isTurnOnFastMatch = @(cheak);
    [[NSUserDefaults standardUserDefaults] setBool:cheak forKey:@"cheakDownLoadInfoAtStart"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)showRecommedInfoAtStart{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_showRecommedInfo) {
        return manager->_showRecommedInfo.boolValue;
    }
    
    BOOL isShowRecommedInfo = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showRecommedInfoAtStart"]) {
        isShowRecommedInfo = [[NSUserDefaults standardUserDefaults] boolForKey:@"showRecommedInfoAtStart"];
    }else{
        [self setShowRecommedInfoAtStart:NO];
    }
    return isShowRecommedInfo;
}
+ (void)setShowRecommedInfoAtStart:(BOOL)show{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_showRecommedInfo = @(show);
    [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"showRecommedInfoAtStart"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash{
    //-1表示没有播放过
    if (!hash.length) return -1;
    
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_lastWatchTimeDic[hash]) {
        return [manager->_lastWatchTimeDic[hash] floatValue];
    }
    
    NSDictionary *tempDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"lastWatchVideosTime"];
    if (!tempDic) {
        manager->_lastWatchTimeDic = [@{} mutableCopy];
        [[NSUserDefaults standardUserDefaults] setObject:manager->_lastWatchTimeDic forKey:@"lastWatchVideosTime"];
    }else{
        manager->_lastWatchTimeDic = [tempDic mutableCopy];
    }
    
    return -1;

}
+ (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time{
    if (!hash.length) return;
    
    UserDefaultManager *manager = [self shareUserDefaultManager];
    
    if (!manager->_lastWatchTimeDic) {
        manager->_lastWatchTimeDic = [@{} mutableCopy];
    }
    if (time < 0) {
        manager->_lastWatchTimeDic[hash] = nil;
    }else{
        manager->_lastWatchTimeDic[hash] = @(time);
    }
    [[NSUserDefaults standardUserDefaults] setObject:manager->_lastWatchTimeDic forKey:@"lastWatchVideosTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)defaultQuality{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_quality) {
        return manager->_quality.integerValue;
    }
    
    NSInteger type = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultScreenShotType"]) {
        type = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultQuality"];
    }else{
        [self setDefaultQuality:0];
    }
    return type;
}

+ (void)setDefaultQuality:(NSInteger)quality{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_quality = @(quality);
    
    [[NSUserDefaults standardUserDefaults] setInteger:quality forKey:@"defaultQuality"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearPlayHistory{
    manager->_lastWatchTimeDic = [NSMutableDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastWatchVideosTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
