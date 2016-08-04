//
//  JHSwichButton.h
//  JHSwichButton
//
//  Created by JimHuang on 16/8/3.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JHSwichButton : NSView
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSColor *signTintColor;
@property (strong, nonatomic) NSColor *leftViewBackgroundColor;
@property (strong, nonatomic) NSColor *rightViewBackgroundColor;
- (void)addTarget:(id)target action:(SEL)action;

@end
