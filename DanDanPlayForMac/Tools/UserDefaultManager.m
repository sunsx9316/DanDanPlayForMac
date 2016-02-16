//
//  UserDefaultManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "UserDefaultManager.h"
@implementation UserDefaultManager
+ (BOOL)turnOnCaptionsProtectArea{
    BOOL captionsProtectArea = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"captionsProtectArea"]) {
        captionsProtectArea = [[NSUserDefaults standardUserDefaults] boolForKey:@"captionsProtectArea"];
    }else{
        [self setTurnOnCaptionsProtectArea: YES];
    }
    return captionsProtectArea;
}
+ (void)setTurnOnCaptionsProtectArea:(BOOL)captionsProtectArea{
    [[NSUserDefaults standardUserDefaults] setBool:captionsProtectArea forKey:@"captionsProtectArea"];
}

+ (NSFont *)danMuFont{
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
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: danMuFont] forKey: @"danMuFont"];
}

+ (CGFloat)danMuOpacity{
    CGFloat value = 100.0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuOpacity"]) {
        value = [[NSUserDefaults standardUserDefaults] floatForKey: @"danMuOpacity"];
    }else{
        [self setDanMuOpacity: 100.0];
    }
    return value;
}
+ (void)setDanMuOpacity:(CGFloat)danMuOpacity{
    [[NSUserDefaults standardUserDefaults] setFloat:danMuOpacity forKey:@"danMuOpacity"];
}

+ (CGFloat)danMuSpeed{
    CGFloat value = 31.0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMuSpeed"]) {
        value = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMuSpeed"];
    }else{
        [self setDanMuSpeed: 31.0];
    }
    return value;
}
+ (void)setDanMuSpeed:(CGFloat)danMuSpeed{
    [[NSUserDefaults standardUserDefaults] setFloat:danMuSpeed forKey:@"danMuSpeed"];
}

+ (NSInteger)danMufontSpecially{
    NSInteger specially = 100;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"danMufontSpecially"]) {
        specially = [[NSUserDefaults standardUserDefaults] floatForKey:@"danMufontSpecially"];
    }else{
        [self setDanMuFontSpecially: 100];
    }
    return specially;
}
+ (void)setDanMuFontSpecially:(NSInteger)fontSpecially{
    [[NSUserDefaults standardUserDefaults] setInteger:fontSpecially forKey:@"danMufontSpecially"];
}
+ (NSImage*)homeImg{
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSUserDefaults standardUserDefaults] stringForKey: @"homeImgPath"]];
    if (!img) {
        img = [NSImage imageNamed:@"home"];
    }
    return img;
}
+ (void)setHomeImgPath:(NSString *)homeImgPath{
    [[NSUserDefaults standardUserDefaults] setObject:homeImgPath forKey:@"homeImgPath"];
}

+ (NSMutableArray *)userFilter{
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] arrayForKey: @"userFilter"] mutableCopy];
    return arr?arr:[NSMutableArray array];
}
+ (void)setUserFilter:(NSArray *)userFilter{
    [[NSUserDefaults standardUserDefaults] setObject:userFilter forKey:@"userFilter"];
}

+ (NSMutableArray *)customKeyMap{
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"customKeyMap"] mutableCopy];
    if (!arr) {
        arr = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultKeyMap" ofType:@"plist"]] mutableCopy];
        [self setCustomKeyMap: arr];
    }
    return arr;
}
+ (void)setCustomKeyMap:(NSArray *)customKeyMap{
    [[NSUserDefaults standardUserDefaults] setObject:customKeyMap forKey:@"customKeyMap"];
}

+ (NSString *)screenShotPath{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"screenShotPath"];
    if (!str) {
        str = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"dandanplay"];
        [self setScreenShotPath: str];
    }
    return str;
}
+ (void)setScreenShotPath:(NSString *)screenShotPath{
    [[NSUserDefaults standardUserDefaults] setObject:screenShotPath forKey:@"screenShotPath"];
}

+ (BOOL)shouldClearCache{
    BOOL clearCache = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clearCache"]) {
        clearCache = [[NSUserDefaults standardUserDefaults] boolForKey:@"clearCache"];
    }else{
        [self setClearCache: NO];
    }
    return clearCache;
}
+ (void)setClearCache:(BOOL)clearCache{
    [[NSUserDefaults standardUserDefaults] setBool:clearCache forKey:@"clearCache"];
}
+ (NSInteger)defaultScreenShotType{
    NSInteger type = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultScreenShotType"]) {
        type = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultScreenShotType"];
    }else{
        [self setDefaultScreenShotType:0];
    }
    return type;
}
+ (void)setDefaultScreenShotType:(NSInteger)type{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"defaultScreenShotType"];
}
@end
