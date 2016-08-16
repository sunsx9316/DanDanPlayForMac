//
//  UserDefaultManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DanDanPlayMessageModel.h"
/**
 *  提示文本的类型
 */
typedef NS_ENUM(NSUInteger, DanDanPlayMessageType) {
    /**
     *  普通加载 200
     */
    DanDanPlayMessageTypeLoadMessage = 200,
    /**
     *  未找到弹幕 201
     */
    DanDanPlayMessageTypeNoFoundDanmaku,
    /**
     *  加载字幕失败 202
     */
    DanDanPlayMessageTypeLoadSubtitleError,
    /**
     *  可以尝试手动搜索 203
     */
    DanDanPlayMessageTypeCanSearchByUser,
    /**
     *  未找到下载文件 204
     */
    DanDanPlayMessageTypeNoFoundDownloadFile,
    /**
     *  文件损坏 205
     */
    DanDanPlayMessageTypeDownloadFileDamage,
    /**
     *  没有更新信息 206
     */
    DanDanPlayMessageTypeNoUpdateInfo,
    /**
     *  缓存文件夹不存在 207
     */
    DanDanPlayMessageTypeNoFoundCacheDirectories,
    /**
     *  清除成功 208
     */
    DanDanPlayMessageTypeClearSuccess,
    /**
     *  清除失败 209
     */
    DanDanPlayMessageTypeClearFail,
    /**
     *  文件不是图片 210
     */
    DanDanPlayMessageTypeFileIsNotImage,
    /**
     *  还原成功 211
     */
    DanDanPlayMessageTypeResetSuccess,
    /**
     *  连接失败 212
     */
    DanDanPlayMessageTypeConnectFail,
    /**
     *  搜索弹幕中 213
     */
    DanDanPlayMessageTypeSearchDamakuLoading,
    /**
     *  视频不存在 214
     */
    DanDanPlayMessageTypeVideoNoFound,
    /**
     *  解析中 215
     */
    DanDanPlayMessageTypeAnalyze,
    /**
     *  分析视频 216
     */
    DanDanPlayMessageTypeAnalyzeVideo,
    /**
     *  下载弹幕 217
     */
    DanDanPlayMessageTypeDownloadingDanmaku,
    /**
     *  下载中 218
     */
    DanDanPlayMessageTypeDownloading,
    /**
     *  发送弹幕成功 219
     */
    DanDanPlayMessageTypeLaunchDanmakuSuccess,
    /**
     *  发送弹幕失败 220
     */
    DanDanPlayMessageTypeLaunchDanmakuFail,
    /**
     *  没有匹配到视频 221
     */
    DanDanPlayMessageTypeNoMatchVideo,
    /**
     *  可以发送弹幕占位字符 222
     */
    DanDanPlayMessageTypeCanLaunchDanmakuPlaceHolder,
    /**
     *  不能发送弹幕占位字符 223
     */
    DanDanPlayMessageTypeCannotLaunchDanmakuPlaceHold
};

//弹幕默认字体大小
#define DANMAKU_FONT_SIZE 25
//字幕默认字体大小
#define SUBTITLE_FONT_SIZE 25

@interface UserDefaultManager : NSObject
//字幕保护区域
+ (BOOL)turnOnCaptionsProtectArea;
+ (void)setTurnOnCaptionsProtectArea:(BOOL)captionsProtectArea;
//弹幕字体
+ (NSFont *)danMuFont;
+ (void)setDanMuFont:(NSFont *)danMuFont;

+ (NSMutableDictionary *)subtitleAttDic;
+ (void)setSubtitleAttDic:(NSDictionary *)subtitleAttDic;
//弹幕透明度
+ (CGFloat)danMuOpacity;
+ (void)setDanMuOpacity:(CGFloat)danMuOpacity;
//弹幕速度
+ (CGFloat)danMuSpeed;
+ (void)setDanMuSpeed:(CGFloat)danMuSpeed;
//弹幕边缘特效
+ (NSInteger)danMufontSpecially;
+ (void)setDanMuFontSpecially:(NSInteger)fontSpecially;
//首页图片
+ (NSImage*)homeImg;
+ (void)setHomeImgPath:(NSString *)homeImgPath;
//用户自定义过滤过滤
+ (NSMutableArray *)userFilter;
+ (void)setUserFilter:(NSMutableArray *)userFilter;
//用户自定义快捷键
+ (NSMutableArray *)customKeyMap;
+ (void)setCustomKeyMap:(NSMutableArray *)customKeyMap;
//默认保存截图路径
+ (NSString *)screenShotPath;
+ (void)setScreenShotPath:(NSString *)screenShotPath;
//弹幕默认缓存路径
+ (NSString *)cachePath;
+ (void)setCachePath:(NSString *)cachePath;
//默认截图保存格式
+ (NSInteger)defaultScreenShotType;
+ (void)setDefaultScreenShotType:(NSInteger)type;
//是否开启快速匹配
+ (BOOL)turnOnFastMatch;
+ (void)setTurnOnFastMatch:(BOOL)fastMatch;
//自动下载更新文件路径
+ (NSString *)autoDownLoadPath;
+ (void)setAutoDownLoadPath:(NSString *)path;
//是否在开始自动检查更新
+ (BOOL)cheakDownLoadInfoAtStart;
+ (void)setCheakDownLoadInfoAtStart:(BOOL)cheak;
//是否在开始显示推荐信心
+ (BOOL)showRecommedInfoAtStart;
+ (void)setShowRecommedInfoAtStart:(BOOL)show;
//记录上次观看时间
+ (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash;
+ (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time;
//在线视频清晰度
+ (NSInteger)defaultQuality;
+ (void)setDefaultQuality:(NSInteger)quality;
//清除播放历史
+ (void)clearPlayHistory;
//播放列表
+ (void)setVideoListArr:(NSArray *)videosArr;
+ (NSArray *)videoList;
//提示文本
+ (DanDanPlayMessageModel *)alertMessageWithType:(DanDanPlayMessageType)type;
@end
