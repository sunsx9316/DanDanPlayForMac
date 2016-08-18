//
//  DanDanPlayMessageModel.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
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

/**
 *  提示文本模型
 */
@interface DanDanPlayMessageModel : NSObject
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) NSString *infomationMessage;
- (instancetype)initWithMessage:(NSString *)message infomationMessage:(NSString *)infomationMessage;
//- (instancetype)initWithType:(DanDanPlayMessageType)type;
+ (instancetype)messageModelWithType:(DanDanPlayMessageType)type;
@end
