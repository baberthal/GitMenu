//
//  GMUDetailViewController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@import GMUDataModel;

@interface GMUDetailViewController : NSViewController

@property(strong) GMUManagedRepo *representedRepo;

@property(weak) IBOutlet NSSplitView *horizontalSplitView;
@property(weak) IBOutlet NSSplitView *verticalSplitView;
@property(weak) IBOutlet NSView *generalInfoView;
@property(weak) IBOutlet NSView *commitsView;
@property(weak) IBOutlet NSView *filesOrDiffsView;

@property(weak) IBOutlet NSPathControl *repoPathControl;

@end
