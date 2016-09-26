//
//  NSProgressIndicator+Tools.m
//  DanDanPlayForMac
//
//  Created by Jim_Huang on 16/9/20.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSProgressIndicator+Tools.h"
#import <CoreImage/CoreImage.h>
#import <objc/runtime.h>

@implementation NSProgressIndicator (Tools)
- (void)setColor:(NSColor *)color {
    objc_setAssociatedObject(self, "color", color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CIFilter *colorPoly = [CIFilter filterWithName:@"CIColorPolynomial"];
    [colorPoly setDefaults];
    CIVector *redVector = [CIVector vectorWithX:color.redComponent Y:0 Z:0 W:0];
    CIVector *greenVector = [CIVector vectorWithX:color.greenComponent Y:0 Z:0 W:0];
    CIVector *blueVector = [CIVector vectorWithX:color.blueComponent Y:0 Z:0 W:0];
    [colorPoly setValue:redVector forKey:@"inputRedCoefficients"];
    [colorPoly setValue:greenVector forKey:@"inputGreenCoefficients"];
    [colorPoly setValue:blueVector forKey:@"inputBlueCoefficients"];
    [self setContentFilters:[NSArray arrayWithObjects:colorPoly, nil]];
}

- (NSColor *)color {
    return objc_getAssociatedObject(self, "color");
}
@end
