//
//  GMURepoTableRowView.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURepoTableRowView.h"
#import "NSColor+Solarized.h"

@implementation GMURepoTableRowView

@synthesize selectionFillColor = _selectionFillColor;
@synthesize selectionStrokeColor = _selectionStrokeColor;
@synthesize selectionFillCornerRadius = _cornerRadius;

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        [self setIBDefaults];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setIBDefaults];
    }

    return self;
}

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    if (self.selectionHighlightStyle == NSTableViewSelectionHighlightStyleNone) {
        return;
    }

    NSRect selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
    [self.selectionStrokeColor setStroke];
    [self.selectionFillColor setFill];
    NSBezierPath *selectionPath =
          [NSBezierPath bezierPathWithRoundedRect:selectionRect
                                          xRadius:self.selectionFillCornerRadius
                                          yRadius:self.selectionFillCornerRadius];
    [selectionPath fill];
    [selectionPath stroke];
}

- (void)setIBDefaults
{
    _selectionFillColor = [[NSColor solarizedCyan] colorWithAlphaComponent:0.65];
    _selectionStrokeColor = [[NSColor solarizedCyan] colorWithAlphaComponent:0.82];
    _cornerRadius = 1.f;
}

@end
