//
//  DDPMacroDefinition.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 2018/10/21.
//  Copyright © 2018 JimHuang. All rights reserved.
//

#ifndef DDPMacroDefinition_h
#define DDPMacroDefinition_h

//弹幕默认字体大小
#define DANMAKU_FONT_SIZE 25
//字幕默认字体大小
#define SUBTITLE_FONT_SIZE 25

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


#define kViewControllerWithId(ID) [[NSStoryboard storyboardWithName:@"Main" bundle: nil] instantiateControllerWithIdentifier: ID]


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#if defined(__cplusplus)
#define let auto const
#define var auto
#else
#define let const __auto_type
#define var __auto_type
#endif

#if DEBUG
#define DDP_KEYPATH(object, property) ((void)(NO && ((void)object.property, NO)), @ #property)
#else
#define DDP_KEYPATH(object, property) @ #property
#endif

#endif /* DDPMacroDefinition_h */
