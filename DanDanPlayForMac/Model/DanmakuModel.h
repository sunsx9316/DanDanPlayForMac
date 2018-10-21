//
//  DanMuModel.h
//  DanDanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DDPBase.h"
@class DanmakuDataModel, LaunchDanmakuModel;
/**
 *  弹幕模型
 */
@interface DanmakuModel : DDPBase
@property (nonatomic, strong)NSArray<DanmakuDataModel*>* comments;
@end

@interface DanmakuDataModel : DDPBase

/**
 弹幕ID
 */
@property (copy, nonatomic) NSString *cid;
/**
 *  Time: 浮点数形式的弹幕时间，单位为秒。
 */
@property (nonatomic, assign) CGFloat time;
/**
 *  Mode: 弹幕模式，1普通弹幕，4底部弹幕，5顶部弹幕。
 */
@property (nonatomic, assign) NSInteger mode;
/**
 *  Color: 32位整形数的弹幕颜色，算法为 R*256*256 + G*256 + B。
 */
@property (nonatomic, assign) NSInteger color;
/**
 *  Message: 弹幕内容文字。\r和\n不会作为换行转义符。
 */
@property (nonatomic, strong) NSString* message;
/**
 *  是否被过滤
 */
@property (assign, nonatomic, getter=isFilter) BOOL filter;
/**
 *  转换成发射用的弹幕模型
 *
 *  @return 发射用的弹幕模型
 */
- (LaunchDanmakuModel *)launchDanmakuModel;
@end

/**
 *  发射用弹幕模型
 */
@interface LaunchDanmakuModel : DDPBase
@property (assign, nonatomic) CGFloat Time;
@property (assign, nonatomic) NSInteger Mode;
@property (assign, nonatomic) NSInteger Color;
@property (assign, nonatomic) NSInteger Timestamp;
@property (assign, nonatomic) NSInteger Pool;
@property (assign, nonatomic) NSInteger UId;
@property (assign, nonatomic) NSInteger CId;
@property (strong, nonatomic) NSString *Token;
@property (strong, nonatomic) NSString *Message;
@end
