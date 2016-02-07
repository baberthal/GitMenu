//
//  JMLColoredView.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "JMLColoredView.h"

@implementation JMLColoredView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [self.backgroundColor setFill];
    [path fill];
}

- (void)dealloc
{
    _backgroundColor = nil;
}

@end
