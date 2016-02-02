//
//  GMUCommitTableCellView.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GTCommit;

@interface GMUCommitTableCellView : NSTableCellView

@property(weak) IBOutlet NSTextField *commitByline;
@property(weak) IBOutlet NSTextField *commitTitle;
@property(strong) GTCommit *representedCommit;

@end
