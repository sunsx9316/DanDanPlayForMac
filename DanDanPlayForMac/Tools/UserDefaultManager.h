//
//  UserDefaultManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DanDanPlayMessageModel.h"
#import "VersionModel.h"

@interface UserDefaultManager : NSObject
+ (instancetype)shareUserDefaultManager;
//字幕保护区域
@property (assign, nonatomic) BOOL turnOnCaptionsProtectArea;
//快速匹配
@property (assign, nonatomic) BOOL turnOnFastMatch;
//程序启动时检查更新
@property (assign, nonatomic) BOOL cheakDownLoadInfoAtStart;
//程序启动时显示推荐页
@property (assign, nonatomic) BOOL showRecommedInfoAtStart;
//反转音量
@property (assign, nonatomic) BOOL reverseVolumeScroll;
//是否第一次启动
@property (assign, nonatomic) BOOL firstRun;
//弹幕透明度
@property (assign, nonatomic) CGFloat danmakuOpacity;
//弹幕速度
@property (assign, nonatomic) CGFloat danmakuSpeed;
//弹幕边缘特效
@property (assign, nonatomic) NSInteger danmakuSpecially;
//默认截图格式
@property (assign, nonatomic) NSInteger defaultScreenShotType;
//默认清晰度
@property (assign, nonatomic) NSInteger defaultQuality;
//主页图片路径
@property (copy, nonatomic) NSString *homeImgPath;
//默认截图路径
@property (copy, nonatomic) NSString *screenShotPath;
//自动下载路径
@property (copy, nonatomic) NSString *autoDownLoadPath;
//补丁路径
@property (copy, nonatomic, readonly) NSString *patchPath;
//下载恢复数据路径
@property (copy, nonatomic, readonly) NSString *downloadResumeDataPath;
//下载视频的路径
@property (copy, nonatomic, readonly) NSString *downloadCachePath;
//弹幕缓存路径
@property (copy, nonatomic) NSString *danmakuCachePath;
//用户屏蔽弹幕设置
@property (strong, nonatomic) NSMutableArray *userFilterArr;
//用户快捷键设置
@property (strong, nonatomic) NSMutableArray *customKeyMapArr;
//播放列表设置
@property (strong, nonatomic) NSMutableOrderedSet *videoListOrderedSet;
//弹幕字体
@property (strong, nonatomic) NSFont *danmakuFont;
//用于记录上个版本
@property (copy, nonatomic) VersionModel *versionModel;
//清除播放历史
- (void)clearPlayHistory;
- (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash;
- (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time;
//获取用户发送的弹幕
+ (NSMutableArray *)userSentDanmaukuArrWithEpisodeId:(NSString *)episodeId;
+ (void)saveUserSentDanmakus:(NSArray *)sentDanmakus episodeId:(NSString *)episodeId;
@end
