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
}

+ (CGFloat)danMuOpacity{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_danMuOpacity) {
        return manager->_danMuOpacity.floatValue;
    }
    
    CGFloat value = 100.0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuOpacity"]) {
        value = [[NSUserDefaults standardUserDefaults] floatForKey: @"danMuOpacity"];
    }else{
        [self setDanMuOpacity: 100.0];
    }
    return value;
}
+ (void)setDanMuOpacity:(CGFloat)danMuOpacity{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_danMuOpacity = @(danMuOpacity);
    
    [[NSUserDefaults standardUserDefaults] setFloat:danMuOpacity forKey:@"danMuOpacity"];
}

+ (CGFloat)danMuSpeed{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_danMuSpeed) {
        return manager->_danMuSpeed.floatValue;
    }
    
    CGFloat value = 31.0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuSpeed"]) {
        value = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMuSpeed"];
    }else{
        [self setDanMuSpeed: 31.0];
    }
    return value;
}
+ (void)setDanMuSpeed:(CGFloat)danMuSpeed{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_danMuSpeed = @(danMuSpeed);
    
    [[NSUserDefaults standardUserDefaults] setFloat:danMuSpeed forKey:@"danMuSpeed"];
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
}

+ (BOOL)shouldClearCache{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    if (manager->_shouldClearCache) {
        return manager->_shouldClearCache.boolValue;
    }
    
    BOOL clearCache = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clearCache"]) {
        clearCache = [[NSUserDefaults standardUserDefaults] boolForKey:@"clearCache"];
    }else{
        [self setClearCache: NO];
    }
    return clearCache;
}
+ (void)setClearCache:(BOOL)clearCache{
    UserDefaultManager *manager = [self shareUserDefaultManager];
    manager->_shouldClearCache = @(clearCache);
    
    [[NSUserDefaults standardUserDefaults] setBool:clearCache forKey:@"clearCache"];
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
}
@end
