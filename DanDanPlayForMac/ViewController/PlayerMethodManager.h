//
//  PlayerMethodManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PlayerLastWatchVideoTimeView.h"

typedef void(^loadLocalDanMuBlock)(NSDictionary *dic);
typedef void(^loadLocalSubtitleBlock)(NSString *path);
@class VLCMediaPlayer, PlayerHUDControl, DanmakuDataModel;
@interface PlayerMethodManager : NSObject
/**
 *  控制view的显示隐藏
 *
 *  @param controlView       需要控制的view
 *  @param rect              view改变的尺寸
 *  @param isHide            是否隐藏
 *  @param completionHandler 回调
 */
+ (void)controlView:(NSView *)controlView withRect:(CGRect)rect isHide:(BOOL)isHide completionHandler:(void(^)(void))completionHandler;
/**
 *  加载本地弹幕
 *
 *  @param block 回调
 */
+ (void)loadLocaleDanMuWithBlock:(loadLocalDanMuBlock)block;
/**
 *  加载本地字幕
 *
 *  @param block 回调
 */
+ (void)loadLocaleSubtitleWithBlock:(loadLocalSubtitleBlock)block;
/**
 *  发射弹幕
 *
 *  @param text              弹幕内容
 *  @param color             弹幕颜色
 *  @param mode              弹幕模式
 *  @param time              弹幕发射时间
 *  @param episodeId         节目ID
 *  @param completionHandler 回调
 */
+ (void)launchDanmakuWithText:(NSString *)text color:(NSInteger)color mode:(NSInteger)mode time:(NSTimeInterval)time episodeId:(NSString *)episodeId completionHandler:(void(^)(DanmakuDataModel *model ,DanDanPlayErrorModel *error))completionHandler;
/**
 *  重设播放视图约束
 *
 *  @param mediaView 播放视图
 *  @param size      视频尺寸
 */
+ (void)remakeConstraintsPlayerMediaView:(NSView *)mediaView size:(CGSize)size;

+ (void)showPlayLastWatchVideoTimeView:(PlayerLastWatchVideoTimeView *)timeView time:(NSTimeInterval)time;
/**
 *  尝试按照路径转换弹幕
 *
 *  @param URL              路径
 *  @param completionHandler 回调
 */
+ (void)convertDanmakuWithURL:(NSURL *)URL completionHandler:(void(^)(NSDictionary *danmakuDic ,DanDanPlayErrorModel *error))completionHandler;
@end
