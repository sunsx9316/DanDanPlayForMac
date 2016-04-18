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
+ (void)setUserFilter:(NSMutableArray *)userFilter;

+ (NSMutableArray *)customKeyMap;
+ (void)setCustomKeyMap:(NSMutableArray *)customKeyMap;

+ (NSString *)screenShotPath;
+ (void)setScreenShotPath:(NSString *)screenShotPath;

+ (NSString *)cachePath;
+ (void)setCachePath:(NSString *)cachePath;

+ (NSInteger)defaultScreenShotType;
+ (void)setDefaultScreenShotType:(NSInteger)type;

+ (BOOL)turnOnFastMatch;
+ (void)setTurnOnFastMatch:(BOOL)fastMatch;

+ (NSString *)autoDownLoadPath;
+ (void)setAutoDownLoadPath:(NSString *)path;

+ (BOOL)cheakDownLoadInfoAtStart;
+ (void)setCheakDownLoadInfoAtStart:(BOOL)cheak;

+ (BOOL)showRecommedInfoAtStart;
+ (void)setShowRecommedInfoAtStart:(BOOL)show;

+ (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash;
+ (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time;

+ (NSInteger)defaultQuality;
+ (void)setDefaultQuality:(NSInteger)quality;

+ (void)clearPlayHistory;

+ (void)setVideoListArr:(NSArray *)videosArr;
+ (NSArray *)videoList;
@end
