//
//  Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/4/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#ifndef Tools_h
#define Tools_h

//一些方法的宏

#define kViewControllerWithId(ID) [[NSStoryboard storyboardWithName:@"Main" bundle: nil] instantiateControllerWithIdentifier: ID]

#define RGBColor(r,g,b) RGBAColor(r,g,b,1)
#define RGBAColor(r,g,b,a) [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


/**
 YYCategories
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
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

#endif /* Tools_h */
