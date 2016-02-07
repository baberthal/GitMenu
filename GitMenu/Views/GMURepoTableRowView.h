//
//  GMURepoTableRowView.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

IB_DESIGNABLE
@interface GMURepoTableRowView : NSTableRowView

@property(atomic, strong) IBInspectable NSColor *selectionFillColor;
@property(atomic, strong) IBInspectable NSColor *selectionStrokeColor;
@property(nonatomic, assign) IBInspectable CGFloat selectionFillCornerRadius;

@end
