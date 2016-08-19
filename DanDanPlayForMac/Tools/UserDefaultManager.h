//
//  UserDefaultManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DanDanPlayMessageModel.h"

//弹幕默认字体大小
#define DANMAKU_FONT_SIZE 25
//字幕默认字体大小
#define SUBTITLE_FONT_SIZE 25

@interface UserDefaultManager : NSObject
@property (assign, nonatomic) BOOL turnOnCaptionsProtectArea;
@property (assign, nonatomic) BOOL turnOnFastMatch;
@property (assign, nonatomic) BOOL cheakDownLoadInfoAtStart;
@property (assign, nonatomic) BOOL showRecommedInfoAtStart;
@property (assign, nonatomic) BOOL reverseVolumeScroll;
@property (assign, nonatomic) CGFloat danmakuOpacity;
@property (assign, nonatomic) CGFloat danmakuSpeed;
@property (assign, nonatomic) NSInteger danmakuSpecially;
@property (assign, nonatomic) NSInteger defaultScreenShotType;
@property (assign, nonatomic) NSInteger defaultQuality;
@property (copy, nonatomic) NSString *homeImgPath;
@property (copy, nonatomic) NSString *screenShotPath;
@property (copy, nonatomic) NSString *autoDownLoadPath;
@property (copy, nonatomic) NSString *danmakuCachePath;
@property (strong, nonatomic) NSMutableArray *userFilterArr;
@property (strong, nonatomic) NSMutableArray *customKeyMapArr;
@property (strong, nonatomic) NSArray *videoListArr;
@property (strong, nonatomic) NSFont *danmakuFont;
+ (instancetype)shareUserDefaultManager;
//清除播放历史
- (void)clearPlayHistory;
- (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash;
- (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time;

//字幕保护区域
//+ (BOOL)turnOnCaptionsProtectArea;
//+ (void)setTurnOnCaptionsProtectArea:(BOOL)captionsProtectArea;
////弹幕字体
//+ (NSFont *)danMuFont;
//+ (void)setDanMuFont:(NSFont *)danMuFont;
//
//+ (NSMutableDictionary *)subtitleAttDic;
//+ (void)setSubtitleAttDic:(NSDictionary *)subtitleAttDic;
////弹幕透明度
//+ (CGFloat)danMuOpacity;
//+ (void)setDanMuOpacity:(CGFloat)danMuOpacity;
////弹幕速度
//+ (CGFloat)danMuSpeed;
//+ (void)setDanMuSpeed:(CGFloat)danMuSpeed;
////弹幕边缘特效
//+ (NSInteger)danMufontSpecially;
//+ (void)setDanMuFontSpecially:(NSInteger)fontSpecially;
////首页图片
//+ (NSImage*)homeImg;
//+ (void)setHomeImgPath:(NSString *)homeImgPath;
////用户自定义过滤过滤
//+ (NSMutableArray *)userFilter;
//+ (void)setUserFilter:(NSMutableArray *)userFilter;
////用户自定义快捷键
//+ (NSMutableArray *)customKeyMap;
//+ (void)setCustomKeyMap:(NSMutableArray *)customKeyMap;
////默认保存截图路径
//+ (NSString *)screenShotPath;
//+ (void)setScreenShotPath:(NSString *)screenShotPath;
////弹幕默认缓存路径
//+ (NSString *)cachePath;
//+ (void)setCachePath:(NSString *)cachePath;
////默认截图保存格式
//+ (NSInteger)defaultScreenShotType;
//+ (void)setDefaultScreenShotType:(NSInteger)type;
////是否开启快速匹配
//+ (BOOL)turnOnFastMatch;
//+ (void)setTurnOnFastMatch:(BOOL)fastMatch;
////自动下载更新文件路径
//+ (NSString *)autoDownLoadPath;
//+ (void)setAutoDownLoadPath:(NSString *)path;
////是否在开始自动检查更新
//+ (BOOL)cheakDownLoadInfoAtStart;
//+ (void)setCheakDownLoadInfoAtStart:(BOOL)cheak;
////是否在开始显示推荐信心
//+ (BOOL)showRecommedInfoAtStart;
//+ (void)setShowRecommedInfoAtStart:(BOOL)show;
//记录上次观看时间

//在线视频清晰度
//+ (NSInteger)defaultQuality;
//+ (void)setDefaultQuality:(NSInteger)quality;
////清除播放历史
//+ (void)clearPlayHistory;
////播放列表
//+ (void)setVideoListArr:(NSArray *)videosArr;
//+ (NSArray *)videoList;

@end
