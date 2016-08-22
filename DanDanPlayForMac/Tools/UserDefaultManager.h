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
//弹幕缓存路径
@property (copy, nonatomic) NSString *danmakuCachePath;
//用户屏蔽弹幕设置
@property (strong, nonatomic) NSMutableArray *userFilterArr;
//用户快捷键设置
@property (strong, nonatomic) NSMutableArray *customKeyMapArr;
//播放列表设置
@property (strong, nonatomic) NSArray *videoListArr;
//弹幕字体
@property (strong, nonatomic) NSFont *danmakuFont;
+ (instancetype)shareUserDefaultManager;
//清除播放历史
- (void)clearPlayHistory;
- (NSTimeInterval)videoPlayHistoryWithHash:(NSString *)hash;
- (void)setVideoPlayHistoryWithHash:(NSString *)hash time:(NSTimeInterval)time;
@end
