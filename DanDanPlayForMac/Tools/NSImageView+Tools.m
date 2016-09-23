//
//  NSImageView+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/9/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSImageView+Tools.h"

//@interface NSImageView ()
//{
//    NSImage *_placeHoldImage;
//}
//@end

@implementation NSImageView (Tools)

- (void)setImageBringPlaceHold:(NSImage *)imageBringPlaceHold {
    if (imageBringPlaceHold == nil) {
        self.image = self.placeHoldImage;
    }
    else {
        self.image = imageBringPlaceHold;
    }
}

- (NSImage *)imageBringPlaceHold {
    return self.image;
}

- (void)setPlaceHoldImage:(NSImage *)placeHoldImage {
    objc_setAssociatedObject(self, "placeHoldImage", placeHoldImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSImage *)placeHoldImage {
    return objc_getAssociatedObject(self, "placeHoldImage");
}

@end
