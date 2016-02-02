//
//  NSView+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/29.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSView+Tools.h"

@implementation NSView (Tools)
- (void)disableSubViews
{
    [self setSubViewsEnabled:NO];
}

- (void)enableSubViews
{
    [self setSubViewsEnabled:YES];
}

- (void)setSubViewsEnabled:(BOOL)enabled
{
    NSView* currentView = NULL;
    NSEnumerator* viewEnumerator = [[self subviews] objectEnumerator];
    
    while( currentView = [viewEnumerator nextObject] )
    {
        if( [currentView respondsToSelector:@selector(setEnabled:)] )
        {
            [(NSControl*)currentView setEnabled:enabled];
        }
        [currentView setSubViewsEnabled:enabled];
        
        [currentView display];
    }
}
@end
