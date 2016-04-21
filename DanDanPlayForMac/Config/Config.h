//
//  Config.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef Config_h
#define Config_h

static NSString *official = @"official";
static NSString *bilibili = @"bilibili";
static NSString *acfun = @"acfun";

//来源枚举
typedef NS_ENUM(NSInteger, JHDanMuSource){
    //官方
    JHDanMuSourceOfficial,
    //b站
    JHDanMuSourceBilibili,
    //a站
    JHDanMuSourceAcfun,
    //发送缓存
    JHDanMuSourceCache
};

//错误
#define kNoMatchError [NSError errorWithDomain:@"nomatchdanmaku" code:200 userInfo: nil]
#define kObjNilError [NSError errorWithDomain:@"objnil" code:201 userInfo: nil]

//提示文本
#define kLoadMessageString @"你不能让我加载 我就加载"
#define kNoFoundDanmakuString @"( ´_ゝ｀)并没有找到弹幕"
#define kSearchByUserString @"可以尝试手♂动搜索"
#define kDownLoadingString @"下载中..."
#define kNoFoundDownLoadFileString @"并没有找到下载的文件"
#define kNoFoundDownLoadFileInformativeString @"→_→可能是下载路径有误 可以尝试手♂动更新"
#define kDownLoadFileDamageString @"文件似乎损坏了"
#define kDownLoadFileDamageInformativeString @"可以重新下载或者尝试手♂动下载"
#define kNoUpdateInfoString @"作者忙着补番 并没有更新ㄟ( ▔, ▔ )ㄏ"
#define kNoFoundCacheDirectoriesString @"(╬ﾟдﾟ)并没有这个文件夹"
#define kNoFoundCacheDirectoriesInformativeString @"你想怎样"
#define kClearSuccessString @"清除成功"
#define kClearFailString @"清除失败"
#define kFileISNOTIMGString @"然而这并不是图片"
#define kResetSuccessString @"还☆原☆大☆成☆功"
#define kResetSuccessInformativeString @"会在下次启动生效"
#define kConnectFailString @"连接出错"
#define kSearchDamakuLoadingString @"挖坟中..."
#define kVideoNoFoundString @"∑(￣□￣)视频不存在"
#define kAnalyzeString @"解析中..."
#define kAnalyzeVideoString @"分析视频..."
#define kDownLoadingDanmakuString @"下载弹幕..."
#define kLaunchDanmakuSuccessString @"发射成功"
#define kLaunchDanmakuFailString @"发射失败"
#define kNoMatchVideoString @"并没有匹配到视频"
#define kCanLaunchDanmakuPlaceHoldString @"回车发送弹幕"
#define kCannotLaunchDanmakuPlaceHoldString @"不能发送弹幕"
//官方的key
#define kDanDanPlayKey @""
//官方的IV
#define kDanDanPlayIV @""

#endif /* Config_h */
