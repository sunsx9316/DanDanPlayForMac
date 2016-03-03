//
//  PlayerViewControllerMethodManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef void(^loadLocalDanMuBlock)(NSDictionary *dic);
@class VLCMediaPlayer, PlayerHUDControl, DanMuDataModel;
@interface PlayerViewControllerMethodManager : NSObject
/**
 *  截图
 *
 *  @param player       播放器
 *  @param snapshotName 截图名称
 */
+ (void)snapShotWithPlayer:(VLCMediaPlayer *)player snapshotName:(NSString *)snapshotName;
/**
 *  获取视频当前时间
 *
 *  @param player 视频播放器
 *
 *  @return 当前时间浮点值
 */
+ (CGFloat)videoTimeWithPlayer:(VLCMediaPlayer *)player;
/**
 *  获取视频总时间
 *
 *  @param player 当前播放器
 *
 *  @return 总时间浮点值
 */
+ (CGFloat)currentTimeWithPlayer:(VLCMediaPlayer *)player;
/**
 *  显示鼠标 hud面板 弹幕发射面板
 *
 *  @param HUDPanel hud面板
 *  @param launchDanmakuView 发射弹幕面板
 */
+ (void)showCursorAndHUDPanel:(PlayerHUDControl *)HUDPanel launchDanmakuView:(NSView *)launchDanmakuView;
/**
 *  隐藏鼠标 hud面板 弹幕发射面板
 *
 *  @param HUDPanel hud面板
 *  @param launchDanmakuView 发射弹幕面板
 */
+ (void)hideCursorAndHUDPanel:(PlayerHUDControl *)HUDPanel launchDanmakuView:(NSView *)launchDanmakuView;
/**
 *  显示弹幕控制器
 *
 *  @param scrollView     弹幕控制器
 *  @param scrollViewRect 显示后的rect
 *  @param button         需要隐藏的按钮
 */
+ (void)showDanMuControllerView:(NSScrollView *)scrollView withRect:(CGRect)scrollViewRect hideButton:(NSButton *)button;
/**
 *  隐藏弹幕控制器
 *
 *  @param scrollView     弹幕控制器
 *  @param scrollViewRect 隐藏后的rect
 *  @param button         需要显示的按钮
 */
+ (void)hideDanMuControllerView:(NSScrollView *)scrollView withRect:(CGRect)scrollViewRect showButton:(NSButton *)button;
/**
 *  显示播放列表
 *
 *  @param playerListView     播放列表
 *  @param playerListViewRect 显示后的rect
 */
+ (void)showPlayerListView:(NSScrollView *)playerListView withRect:(CGRect)playerListViewRect;
/**
 *  隐藏播放列表
 *
 *  @param playerListView     播放列表
 *  @param playerListViewRect 隐藏后的rect
 */
+ (void)hidePlayerListView:(NSScrollView *)playerListView withRect:(CGRect)playerListViewRect;
/**
 *  加载本地弹幕
 *
 *  @param block 回调
 */
+ (void)loadLocaleDanMuWithBlock:(loadLocalDanMuBlock)block;
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
+ (void)launchDanmakuWithText:(NSString *)text color:(NSInteger)color mode:(NSInteger)mode time:(NSTimeInterval)time episodeId:(NSString *)episodeId completionHandler:(void(^)(DanMuDataModel *model ,NSError *error))completionHandler;
@end
