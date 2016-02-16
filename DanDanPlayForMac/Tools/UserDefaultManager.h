//
//  UserDefaultManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultManager : NSObject
+ (BOOL)turnOnCaptionsProtectArea;
+ (void)setTurnOnCaptionsProtectArea:(BOOL)captionsProtectArea;

+ (NSFont *)danMuFont;
+ (void)setDanMuFont:(NSFont *)danMuFont;

+ (CGFloat)danMuOpacity;
+ (void)setDanMuOpacity:(CGFloat)danMuOpacity;

+ (CGFloat)danMuSpeed;
+ (void)setDanMuSpeed:(CGFloat)danMuSpeed;

+ (NSInteger)danMufontSpecially;
+ (void)setDanMuFontSpecially:(NSInteger)fontSpecially;

+ (NSImage*)homeImg;
+ (void)setHomeImgPath:(NSString *)homeImgPath;

+ (NSMutableArray *)userFilter;
+ (void)setUserFilter:(NSArray *)userFilter;

+ (NSMutableArray *)customKeyMap;
+ (void)setCustomKeyMap:(NSArray *)customKeyMap;

+ (NSString *)screenShotPath;
+ (void)setScreenShotPath:(NSString *)screenShotPath;

+ (BOOL)shouldClearCache;
+ (void)setClearCache:(BOOL)clearCache;

+ (NSInteger)defaultScreenShotType;
+ (void)setDefaultScreenShotType:(NSInteger)type;
@end
