//
//  NSString+KeyEvent.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSString (KeyEvent)
+ (NSString*) specialKeycodeToString:(NSEvent*)event;
+ (NSString*) stringWithKeyEventCharactersIgnoringModifiers:(NSEvent*)event;
@end
